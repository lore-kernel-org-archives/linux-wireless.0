Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39872 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3FFUxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 16:53:22 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so1856505bkb.5
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 13:53:20 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
Date: Thu, 6 Jun 2013 22:53:00 +0200
Cc: "C.B. Wang" <wtwangcb@gmail.com>
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com> <201306061309.12781.chunkeey@googlemail.com> <CAB-Tk72epLsrQZ36bD2+RGDJgrMiYbMaK8-82=NQ8_fon8NQMw@mail.gmail.com>
In-Reply-To: <CAB-Tk72epLsrQZ36bD2+RGDJgrMiYbMaK8-82=NQ8_fon8NQMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201306062253.00787.chunkeey@googlemail.com> (sfid-20130606_225325_521691_91FBAF4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Readded ML).

On Thursday, June 06, 2013 02:21:58 PM C.B. Wang wrote:
> > maybe by the ar7010+ar92xy combo
> Yes.The ar9280 and ar9285 all support spectral analysis.Will
> ar9170+ar9104 combo also do the job?
No idea. I don't have the PHY docs, just the MAC.
 
> >Can you tell me on what page/chapter?
> On page 19,chapter 17,it says "The OFDM system also provides a
> “half-clocked” operation using 10 MHz channel spacings with data com-
> munications capabilities of 3, 4.5, 6, 9, 12, 18, 24, and 27 Mbit/s."
> Also on page 31,there's a table describing OFDM PHY characteristics of
> 20MHz and 10MHz channel spacing for 802.11j.
Different page numbers here. So let's just stick to the chapter.

Anyway, If I'm reading it correctly it looks like OF1.7 aka 
"10 MHz Channel spacing" is marked as an "O"ptional feature in A4.8.
The same seems to be true for the 4.9 GHz band (marked as optional
in OF3.12 in this old doc)?! 

So, was this all a bit pointless? Because, as far as I can tell the
driver is 802.11j "compliant" as it is. Therefore let's close the
case with: "al[l|ready] done!".

Regards,
	Chr
