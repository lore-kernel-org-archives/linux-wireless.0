Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55000 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbbINIG6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 04:06:58 -0400
Message-ID: <1442218015.2075.0.camel@sipsolutions.net> (sfid-20150914_100710_440690_37B85ADE)
Subject: Re: How to use hwsim?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ramprasad Vempati <ramprasad.vempati@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 14 Sep 2015 10:06:55 +0200
In-Reply-To: <CAB6w8ekO7YW224ujkEH34D-qyvoHe3p6bWwZcBTd_tovRMraxw@mail.gmail.com> (sfid-20150913_190849_721440_A8334A7E)
References: <CAB6w8ekO7YW224ujkEH34D-qyvoHe3p6bWwZcBTd_tovRMraxw@mail.gmail.com>
	 (sfid-20150913_190849_721440_A8334A7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-09-13 at 22:38 +0530, Ramprasad Vempati wrote:
> Hi,
> 
> I've got hwsim source code from:
> http://git.sipsolutions.net/hwsim.git. I could compile it.
> 
>  And I see binary-hwsim is created after compilation.
> 
> But there isn't any help on how do I use this. Can someone help me
> with these details?
> 

This tool is practically irrelevant.

Look at the hwsim tests in wpa_supplicant instead.

johannes
