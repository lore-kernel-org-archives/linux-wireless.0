Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:44729 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZAXQFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 11:05:42 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2924923fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 08:05:41 -0800 (PST)
From: "Diego E. 'Flameeyes' Petteno`" <flameeyes@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Tony Vroon <tony@linx.net>
Subject: Re: [ANN] crda v1.0.0
Date: Sat, 24 Jan 2009 17:05:38 +0100
Message-Id: <1232813139-21462-1-git-send-email-flameeyes@gmail.com> (sfid-20090124_170545_913297_01FD1F1B)
In-Reply-To: <1232812557.19657.6.camel@localhost>
References: <1232812557.19657.6.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than parallel build there is a change in Makefile that breaks
building with --as-needed, I've fixed it in the patch I'm sending.

HTH,
Diego

P.S.: resending, I start to get pretty angry with git-send-email just
as well as stg-mail ...

