Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61883 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbXFCSvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 14:51:03 -0400
Message-ID: <46630D95.4070101@lwfinger.net>
Date: Sun, 03 Jun 2007 13:51:01 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Olivier Cornu <o.cornu@gmail.com>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net> <7b4bf7ff0706030333j21152541hed9384e965cacaa9@mail.gmail.com>
In-Reply-To: <7b4bf7ff0706030333j21152541hed9384e965cacaa9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Olivier Cornu wrote:
> 
> What if two different mac80211 device drivers need two different initial 
> rates?

This situation has not changed, except that the user gets to pick the initial rate, not the software 
designer of rc80211_simple.

Larry
