Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2FMPhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 11:37:09 -0400
Date: Wed, 13 Jun 2012 10:37:03 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 3/9] brcm80211: smac: remove unused code for 40MHz
 channels
Message-ID: <20120613153703.GE3490@thinkpad-t410> (sfid-20120613_173714_505870_658EC18B)
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-4-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338906849-26135-4-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 05, 2012 at 09:34:03AM -0500, Seth Forshee wrote:
> This code has been kept around in anticipation of adding support for
> 40MHz channels, but subsequent patches to better integrate with mac80211
> regulatory support will render it completely broken. Therefore we should
> go ahead and remove it.
> 
> Keep these changes separate from other cleanup patches in order to make
> it easier to resurrect 40MHz channel support at some point in the
> future.

Arend, can I add your Reviewed-by tag for this one?

