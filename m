Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44442 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3BDXN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 18:13:58 -0500
Received: by mail-oa0-f54.google.com with SMTP id n12so4279013oag.41
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 15:13:57 -0800 (PST)
Message-ID: <511040B0.5040701@lwfinger.net> (sfid-20130205_001412_011761_823B4646)
Date: Mon, 04 Feb 2013 17:13:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
In-Reply-To: <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2013 05:00 PM, Thomas Rosenkranz wrote:
> btw. if I do:
> $ sudo modprobe -r 8192cu
> the system crashes

That is a bug in the Realtek driver.

Larry


