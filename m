Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40980 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0IWMuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:50:15 -0400
Date: Thu, 23 Sep 2010 15:50:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
Message-ID: <20100923125001.GS4580@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
 <20100923114528.GL4580@legolas.emea.dhcp.ti.com>
 <1285244253.3231.75.camel@chilepepper>
 <20100923122048.GO4580@legolas.emea.dhcp.ti.com>
 <AANLkTikN37=O8rnFkBfuJex25DdNPEieioL5jgenpoYY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <AANLkTikN37=O8rnFkBfuJex25DdNPEieioL5jgenpoYY@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Sep 23, 2010 at 07:46:33AM -0500, Ohad Ben-Cohen wrote:
>> irq = platform_get_irq(pdev, 0);
>
>only problem is that there is no platform device involved here :)

heh, I thought the omap_beagle_vwlan_device was it, but it's only for
the regulator :-p

nevermind.

-- 
balbi
