Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYHSJFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 05:05:00 -0400
Message-ID: <ee101a74bd16a9467853b5ac049c5da4.squirrel@secure.sipsolutions.net>
In-Reply-To: <48AA887D.5090307@monom.org> 
References: <48AA887D.5090307@monom.org>
Date: Tue, 19 Aug 2008 11:04:58 +0200 (CEST)
Subject: Re: QoS and DSCP
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Daniel Wagner" <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Wagner wrote:
> So my question is, is my approach with iptables and DSCP supposed to work?

The honest answer probably is: we don't know either, and it depends on the
drivers on both sides and the AP in the middle...

johannes
