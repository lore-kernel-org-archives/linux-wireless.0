Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm10.bullet.mail.bf1.yahoo.com ([98.139.212.169]:42075 "HELO
	nm10.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752648Ab2DNKvV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 06:51:21 -0400
Message-ID: <1334400680.99012.YahooMailClassic@web161603.mail.bf1.yahoo.com> (sfid-20120414_125125_578073_44E9671C)
Date: Sat, 14 Apr 2012 03:51:20 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Stanislaw,

I've been away for a while, apologies for not participating in solving the duplicate packet issue. I reviewed your work on the subject and the patches you've submitted. Thank you for your contribution and keeping me informed.

With latest patches, I experience no more duplicate packets or significant data loss. The only issue remaining is Power Save. When PS is on, the latency is ridiculously high and packet loss occurrences are present. PS switched off keeps everything running smooth and problem-free.

Walter


--- On Mon, 2/20/12, Walter Goldens <goldenstranger@yahoo.com> wrote:

> From: Walter Goldens <goldenstranger@yahoo.com>
> Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
> To: "Stanislaw Gruszka" <sgruszka@redhat.com>
> Cc: linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
> Date: Monday, February 20, 2012, 6:52 PM
> 
>
> Walter
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

