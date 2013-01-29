Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3A2L4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 06:56:09 -0500
Message-ID: <1359460592.8108.18.camel@jlt4.sipsolutions.net> (sfid-20130129_125612_602302_66F49496)
Subject: Re: [PATCH 0/3] iw: mesh power save
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 29 Jan 2013 12:56:32 +0100
In-Reply-To: <1358510732-32767-1-git-send-email-marco@cozybit.com> (sfid-20130118_130542_627397_E68BC9E5)
References: <1358510732-32767-1-git-send-email-marco@cozybit.com>
	 (sfid-20130118_130542_627397_E68BC9E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-18 at 13:05 +0100, Marco Porsch wrote:
> The following commits cover all neccessary iw commands for mesh
> power save. Beacon interval, DTIM period, default power mode and
> awake window are accessed as part of the mesh params. The
> link-specific power modes are set for peer STA.

Applied.

johannes

