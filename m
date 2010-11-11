Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:49465 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932104Ab0KKCyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 21:54:20 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0525444057
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:54:18 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7] iw: Add antenna configuration commands
Date: Thu, 11 Nov 2010 11:54:32 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <20101110035122.23770.72735.stgit@localhost6.localdomain6> <1289404599.3748.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289404599.3748.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011111154.32969.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu November 11 2010 00:56:39 Johannes Berg wrote:
> On Wed, 2010-11-10 at 12:51 +0900, Bruno Randolf wrote:
> > +COMMAND(set, antenna, "<bitmap> | all | tx <bitmap> rx <bitmap>",
> 
> I think the parser is too complicated, how about
> 
> "all | <bitmap> | <tx bitmap> <rx bitmap>

Sure. I'll work on that once / if the nl80211 part gets accepted.

bruno
