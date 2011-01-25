Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2710 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1AYLZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 06:25:57 -0500
From: "Roland Vossen" <rvossen@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 25 Jan 2011 03:24:38 -0800
Subject: RE: [PATCH] staging: brcm80211: bugfix for softmac crash on
 multi cpu configurations
Message-ID: <400C43189542CE41BC0A5B252FC90136952F08D15D@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1295952716-16161-1-git-send-email-rvossen@broadcom.com>,<20110125111813.GA14763@suse.de>
In-Reply-To: <20110125111813.GA14763@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>Should this also go to the .37 stable kernel tree?

Yes it should. Should I send you a patch for the .37 stable kernel tree ?

Thanks, Roland.
