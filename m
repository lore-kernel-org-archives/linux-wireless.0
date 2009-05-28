Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64084 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbZE1PWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 11:22:54 -0400
Subject: Re: [RFT 2/2] ar9170: add AVM FRITZ devices
From: Pavel Roskin <proski@gnu.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@Atheros.com, Stephen.Chen@Atheros.com,
	Michael.Fortin@Atheros.com, Johnny.Cheng@Atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org
In-Reply-To: <1243495071.16631.4.camel@localhost.localdomain>
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
	 <1243475326-28867-3-git-send-email-lrodriguez@atheros.com>
	 <1243495071.16631.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 28 May 2009 11:22:38 -0400
Message-Id: <1243524158.19748.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-28 at 09:17 +0200, Marcel Holtmann wrote:

> can't you make this part of use_device_id table? Syncing up with product
> ids in two places is not a good idea.

It would be even better to use an internal chip ID, an equivalent to the
SREV register in ath5k and ath9k, if it exists in ar9170.

-- 
Regards,
Pavel Roskin
