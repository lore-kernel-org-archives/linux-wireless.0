Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58108 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751276AbZGaXPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 19:15:10 -0400
Message-ID: <4A737AFC.40301@gmx.de>
Date: Sat, 01 Aug 2009 01:15:08 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] compat-2.6:  Makefile: fixed test expressions for target
 install
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>	 <4A733CDE.4060801@gmx.de> <1249066564.20276.3.camel@mj>
In-Reply-To: <1249066564.20276.3.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2009 08:56 PM, Pavel Roskin wrote:

> No, I didn't mean that.  I meant:
> 
> if [ -z "" ] && [ -z "" ]; then echo "both empty"; fi
> ...
> We should not rely on any bash features as /bin/sh may not be bash at
> all.

Agreed. Will repost the patch.

