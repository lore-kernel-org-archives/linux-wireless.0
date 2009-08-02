Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44800 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZHBAEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 20:04:13 -0400
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 17:04:08 -0700
Message-Id: <1249171448.3491.32.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> Althoug GPS is a technology w/o transmitting radio
> and thus not a primary candidate for rfkill switch,
> rfkill gives unified interface point for devices with
> wireless technology.
> 
> The input key is not supplied as it is too be deprecated.
> 
> Cc: johannes@sipsolutions.net
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

we don't have a GPS subsystem, but even without it, I think this is a
good thing to have.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Please also send a patch updating the rfkill userspace utility.

Regards

Marcel


