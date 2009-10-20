Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47460 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZJTKo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 06:44:56 -0400
Received: by fxm18 with SMTP id 18so6238468fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 03:45:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2d0a357f0910200334g7cdacb2bh351f20f3afa3932c@mail.gmail.com>
References: <717B3566C64F54459B25922289704B8E6DF4D5@susday7667.TD.teradata.com>
	 <2d0a357f0910200334g7cdacb2bh351f20f3afa3932c@mail.gmail.com>
Date: Tue, 20 Oct 2009 11:45:00 +0100
Message-ID: <3ace41890910200345i7ca796b2s9b26a6f465d066db@mail.gmail.com>
Subject: Re: 'linux-wireless@vger.kernel.org'
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>,
	"Kristofik, Juraj" <Juraj.Kristofik@teradata.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 11:34 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Hi,
>
> there is no need to sent several times the same email to this mailing-list.
> As I suggested to you on IRC, read the document "How To Ask Questions
> The Smart Way", especially "Use meaningful, specific subject headers"
> [1].
> To be precise:
> An empty subject line or none-saying one is not helpful.
> Furthermore, a (significant) subject line is often used for
> referencing (for bug-reports or on other mailing-lists).
>
> Kind Regards,
> - Sedat -

Ditto both of the comments (lack of meaningful subject, and multiple postings).

Error 17 is "File Exists" apparently - I am not the author of the said
relevant code, and I am just writing of my understanding of it -
Feel free to have a go yourself - it is at net/mac80211/main.c .

>
> [1] <http://www.catb.org/~esr/faqs/smart-questions.html#bespecific>
>
> On Tue, Oct 20, 2009 at 12:03 PM, Kristofik, Juraj
> <Juraj.Kristofik@teradata.com> wrote:
>>
>> Hello,
>>
>> I would like to ask if you would be willing to help me in the problem I
>> am experiencing.
>>
>> I have notebook toshiba tecra M6 with Intel(R) PRO/Wireless 3945ABG/BG
>> wifi card, that is working normally in windows.
>>
>> I installed back-track 4 pre final linux on usb drive and followed the
>> guide here (using root account):
>> http://forums.remote-exploit.-org/backtrack-4-working--hardware/27565-bt
>> 4-pre-final--driver-iwl3945-injection--solved.html#post157700
>>
>> I have installed lastest firmware for my wifi
>> (iwlwifi-3945-ucode-15.32.2.9) and compat-wireless-2.6.32-rc4 drivers.
>>
>> However I am experiencing problems with loading drivers and receive
>> error: iwl3945 0000:02:00.0: Failed to register hw (error -17)
>>
>> Can you please provide any help with what this error means?
>>
>> Please see my dmseg in attachment.
>>
>> --
>> Regards,
>> Juraj Kristofik
>>
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
