Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57144 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1DUUZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:25:17 -0400
Received: by pwi15 with SMTP id 15so50987pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 13:25:16 -0700 (PDT)
Message-ID: <4DB092A7.6070100@lwfinger.net>
Date: Thu, 21 Apr 2011 15:25:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Ralink 3090 must load rt3090.bin firmware, not rt2860.bin.
References: <alpine.LFD.2.00.1104212222470.9925@mail.embedromix.ro>
In-Reply-To: <alpine.LFD.2.00.1104212222470.9925@mail.embedromix.ro>
Content-Type: multipart/mixed;
 boundary="------------030601080800090908070707"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030601080800090908070707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/21/2011 02:25 PM, Catalin(ux) M. BOIE wrote:
> Hello.
>
> Please apply it.
> Thank you!
>
> P.S. Please keep me in To/CC.
>
> --
> Catalin(ux) M. BOIE
> http://kernel.embedromix.ro/

NACK. That version of rt2860.bin is really old.

Please remove your patch and try with the attached version of rt2860.bin. It is 
version 29.

Larry

--------------030601080800090908070707
Content-Type: application/octet-stream;
 name="rt2860.bin"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rt2860.bin"

AgNeAgKxIiL///8CAYL//////wIAHv//////AgEzwODA8MCDwILA0HXQGMKvMEUDEhAJkAQW
4DDjA3QI8JAEFOAg5wMCAMt0gPCQcBLg9S+QBATgJM9gMBRgQiTiYEcUYFUkIXBg5VUk/mAH
FGAIJAJwCH0BgCh9AoAkkHAQ4PVQhS9A0gGAPuVVZANgBOVVcAR9AoAJhS9B0gKAKa1Vry8S
Ao2AIJBwEOD1R5BwEeD1RBIQJYAGkHAQ4PVF5P2vLxICjdIEkHAT5PDSr9DQ0ILQg9Dw0OAy
kHAq4DDhU8KvkHAo4JAQHPCQcCngkBAd8JBwKuCQEB7wkBAc4PUwkBAe4CDh85AQHOCQcCjw
kBAd4JBwKfCQEB7gkHAq8DBKDZBwJOBEAfCQAix0//DCBdKvIsDgwPDAg8CCwNDowODpwODq
wODrwODswODtwODuwODvwODCrzBFAxIQEtKv0OD/0OD+0OD90OD80OD70OD60OD50OD40NDQ
gtCD0PDQ4DLA4MDwwIPAgsDQddAQwq8wRQMSEAwwWArlVGAEFVSAAsJYMFkK5VBgBBVQgALC
WdVTBzBgBBVG0gQwRQMSEA/CjdKv0NDQgtCD0PDQ4DISAtMwRQMSEAMwAQYgCQMSEBwwAgYg
CgMSEB8wAwYgCwMSEB8wBAYgDAMSECIgEwkgEQblK0UsYAPTgAHDkqkSAuyAv8JD0kXk9SD1
IfVT9Ub1K/UswkL1UfVS9VWQBBh0gPCQBBp0CPDCGcIYwhoiyO/I5voI5kpgDMjvyAjmFhhw
ARbDIu0k//3sNP/I78j2CMbtxtMi0IPQgvjkk3ASdAGTcA2jo5P4dAGT9YKIg+RzdAKTaGDv
o6OjgN/v9GAf5P4SA2rgtP8SEgNq7/B0HC71guQ0cPWD7fAiDr4E4yLA4MDwwIPAgsDQddAI
wq8wRQMSEAbSr9DQ0ILQg9Dw0OAywq8SAAYSAhQSAxzk9SL1R5AEAHSA8NKvIjBFAxIQFeUg
cAMgEAMwEQNDhwEiwCp0A8DgwILAg3UqCiLAKnQDwODAgsCDdSoYInWJAuT1jPWK9Yj1uPXo
dZAY0ox1qAUizu/O7mAIf/8SA4AegPUiyO/I5mADFsMi7RT20yLI78jmYAYW5iT/syLDInh/
5PbY/XWBXwIB0HQULvWC5DRw9YMi75ADfpOQAwBzChjvYAMfgPoi////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////wIQKAIQ
OwIQPAISuAISuQITPgITP8Mi//8CFlYCF2sCFCoCE0AwBQYgDQMSANgwBgYgDgMSGF4iIpAE
FOAg5wMCEreQcBLg9VaQBATgEgJnEU4wESUxEIczEKo0EMM1EVdQEXtREYRSEYRTEYRUEcVV
EdxwEgdxEjRyEl6AEoGDAAASt3UkBXUl3JBwn3QS8NIY0mF1NQ3kkHAT8OVW9HADAhK3AhKq
whiQARTgVP3w5JBwE/DlVvRwAwIStwISquVVZAJwN5BwEOBgCJABDXQJ8IAl5TQUYAoUYA8U
YBQkA3AWkAENdAjwgA6QAQ10C/CABpABDXQb8H0BgAJ9Aq9WEgKNkHAR4CT/khuQBBR0gPDk
kHAT8OVW9HADAhK3AhKqIAIDMAMdfQKvVhICjZAEFHSA8OSQcBPw5Vb0cAMCErcCEqqFVkHS
AiKQcBHgJP+SGyKQcBDgVH9kAmADAhK3kHAR4GQIYAjgZCBgAwISt3VOA3VPICKQcBHgJP+S
RyKQBATgJeAkXfVXkHAQ4P90RyVX+MbvxpBwEeD/dEglV/jG78bk/a9WEgKNkAQUdIDw5JBw
E/DlVvRwAwIStwISquVHtAcIkHAR4FQH9Sbk/a9WEgKN0gQikHAQ4P6QcBHg/e345vVX/a9W
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
GY+CjoPgtP8HBTfk9TaAWeT1N4+CjoPwgE/lNnXwBoR0CCXw9YLkNBD1g+D9j4KOg+D8bXAw
kHCI4ATwo+D905U3QAKAAq03kHCJ7fAFNwU25TZ18AaEdIol8PWC5DRw9YPs8IAD5PU3D78A
AQ7vVH9gCuU3w5ROUAMCGRDlN7ROA9OAAcMiAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALlOs=
--------------030601080800090908070707--
