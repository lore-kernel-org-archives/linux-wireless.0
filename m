Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47481 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1CLUTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2011 15:19:16 -0500
Received: by bwz15 with SMTP id 15so3529932bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Mar 2011 12:19:14 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Frans Leerink <f.leerink@xs4all.nl>
Subject: Re: Wireless Network, openSUSE11.4 and my Network Controller Intersil Corporation ISL3890 [Prim GT / Prism Duette] [1260:3890] and its (prism)driver
Date: Sat, 12 Mar 2011 21:19:08 +0100
Cc: linux-wireless@vger.kernel.org
References: <201103122011.38936.f.leerink@xs4all.nl>
In-Reply-To: <201103122011.38936.f.leerink@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103122119.08782.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 12 March 2011 20:11:38 Frans Leerink wrote:
> I am still hapilly using my Medion MD41300 Notebook from june 2004. This 
> Notebook is equipped with a 3,06GHz Mobile Intel Pentium 4 processor + 
> Hyper Threading Technology,  1MB of memory and Intersil's Corporation 
> ISL3890 [Prim GT / Prism Duette] [1260:3890] Network Controller [0280].
> 
Question: Have you already filed an openSUSE bug-report?

Because I've such a card as well and it works pretty much "out of the box"
(once the fw is installed - which you have!).

In your case the device is able to pick up two (similar?) APs in
the vicinity, but it fails to connect.

However, Google has come up with some stuff (at least for 11.3):

> http://forums.opensuse.org/english/get-technical-help-here/wireless/443333-solved-wireless-authentication-failed-isl3890-prism-gt-prism-duette.html"
quote:
"I finally got a solution: install compat-wireless".
[ http://wireless.kernel.org/en/users/Download ]

Regards,
	Chr
