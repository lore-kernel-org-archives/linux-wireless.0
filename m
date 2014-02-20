Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaBTK71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 05:59:27 -0500
Message-ID: <1392893955.5073.27.camel@jlt4.sipsolutions.net> (sfid-20140220_115931_253907_47E2706B)
Subject: Re: [PATCH] [PATCH v2]cfg80211: Pass TDLS peer capability
 information in tdls_mgmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	c_ppotte@qti.qualcomm.com, djindal@qti.qualcomm.com
Date: Thu, 20 Feb 2014 11:59:15 +0100
In-Reply-To: <1392893529-8433-1-git-send-email-usdutt@qti.qualcomm.com> (sfid-20140220_115243_679599_BA18260E)
References: <1392893529-8433-1-git-send-email-usdutt@qti.qualcomm.com>
	 (sfid-20140220_115243_679599_BA18260E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:22 +0530, Sunil Dutt Undekari wrote:
> While framing the TDLS Setup Confirmation frame, the driver needs to
> know if the TDLS peer is VHT/HT/WMM capable and thus shall construct
> the VHT/HT operation / WMM parameter elements accordingly. Supplicant
> determines if the TDLS peer is VHT/HT/WMM capable based on the
> presence of the respective IEs in the received TDLS Setup Response frame.
> 
> The host driver should not need to parse the received TDLS Response
> frame and thus, should be able to rely on the supplicant to indicate
> the capability of the peer through additional flags while transmitting
> the TDLS Setup Confirmation frame through tdls_mgmt operations.

Applied.

johannes

