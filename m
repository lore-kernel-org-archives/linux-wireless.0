Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15271 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab0DPWKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 18:10:31 -0400
Subject: Re: Compiling ar9170 on 2.6.30
From: Pavel Roskin <proski@gnu.org>
To: Eric Siegel <nticompass@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4BC776F4.80600@gmail.com>
References: <4BC776F4.80600@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 18:10:26 -0400
Message-Id: <1271455826.16507.45.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-15 at 16:28 -0400, Eric Siegel wrote:
> I was trying to compile ar9170 from today's tarball, and I got a compile
> error.
> ar9170/main.c:2060: error: expected ‘;’ before ‘mchash’

The bleeding edge compat-wireless is currently broken.  Please use
compat-wireless-2.6.34-rc4.tar.bz2 from
http://wireless.kernel.org/en/users/Download/stable/

-- 
Regards,
Pavel Roskin
