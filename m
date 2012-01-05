Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1696 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2AEKID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 05:08:03 -0500
Message-ID: <4F057673.8000807@broadcom.com> (sfid-20120105_110808_367464_6584F8F4)
Date: Thu, 5 Jan 2012 11:07:47 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stephen Hemminger" <shemminger@vyatta.com>
cc: "John W.Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"Alwin Beukers" <alwin@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: make ethtool_ops const
References: <20120104145251.5102b435@nehalam.linuxnetplumber.net>
In-Reply-To: <20120104145251.5102b435@nehalam.linuxnetplumber.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2012 11:52 PM, Stephen Hemminger wrote:
> All usage of ethtool_ops should be const; also add comma at end
> of initializer list.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> ---
> Patch against net-next

Assuming net-next and wireless-next are in sync.

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


