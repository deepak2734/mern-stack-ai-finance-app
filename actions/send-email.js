import { Resend } from "resend";

export const resend = new Resend(process.env.RESEND_API_KEY || "");

export async function sendEmail({ to, subject, react }) {
  try {
    // Check if API key exists before attempting to send
    if (!resendApiKey) {
      console.error("Cannot send email: RESEND_API_KEY is not configured");
      return {
        success: false,
        error: "Email service not configured",
      };
    }

    const data = await resend.emails.send({
      from: "Finance App <onboarding@resend.dev>",
      to,
      subject,
      react,
    });

    return { success: true, data };
  } catch (error) {
    console.error("Failed to send email:", error);
    return { success: false, error };
  }
}
