Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62371 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab0DCVkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 17:40:05 -0400
Received: by gyg13 with SMTP id 13so1494982gyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 14:40:04 -0700 (PDT)
Message-ID: <4BB7B5B2.3080102@lwfinger.net>
Date: Sat, 03 Apr 2010 16:40:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gus Wirth <gwirth79@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8187b - naughty behaviour
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com> <4BB7660A.3030900@lwfinger.net> <4BB79F15.2040307@gmail.com>
In-Reply-To: <4BB79F15.2040307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2010 03:03 PM, Gus Wirth wrote:
> 
> How is it that you get a reported Bit Rate of 11Mbps from iwconfig but
> your actual measured bitrate is about 13Mbps? Is there something wrong
> with the way iwconfig reports what's going on? Or is there some
> compression going on that is not accounted for?

The 11 Mb/s Bit Rate was at a distance of 15 m where the transmit rate
was 3 Mb/s. The transmit rate of 13 Mb/s was at 2 m, where the Bit Rate
was 24 Mb/s or higher.

No magic. You will never see a throughput rate higher than ~0.5 the bit
rate reported by iwconfig.

Larry



