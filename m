Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1HaGa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:30:26 -0400
Subject: Re: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
From: Johannes Berg <johannes@sipsolutions.net>
To: Suraj Sumangala <surajs@qca.qualcomm.com>
Cc: linville@tuxdriver.com, ath6kl-devel@qualcomm.com,
	senthilb@qca.qualcomm.com, vipimeht@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com> (sfid-20110831_082525_612687_34CC3735)
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:30:17 +0200
Message-ID: <1314772217.4161.10.camel@jlt3.sipsolutions.net> (sfid-20110831_083029_549333_45A06AED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 11:55 +0530, Suraj Sumangala wrote:
> This patch propose a new set of NL80211 commands and attributes
> to communicate information about ongoing Bluetooth operations to the
> wifi chip in case of a Bluetooth-WiFi coex solution.
> 
> It can then be used by the WiFi hardware to understand the requirements
> of a Bluetooth radio and manage shared resources between
> Bluetooth and Wifi modules better.
> 
> The proposed Bluetooth information sent are mainly regarding Bluetooth
> SCO, A2DP connection, inquiry and master/slave role of Bluetooth chip.
> 
> This information can be sent by a userspace Bluetooth filter utility
> application to the WiFi driver.

???
Why would this need a userspace utility? Are you cloning some sort of
windows architecture here?

johannes

