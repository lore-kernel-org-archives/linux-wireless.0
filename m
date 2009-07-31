Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:50303 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZGaNgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 09:36:35 -0400
Date: Fri, 31 Jul 2009 14:36:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tim Gardner <timg@tpi.com>
Cc: linux-acpi@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Fix rfkill state queries
Message-ID: <20090731133633.GA3342@srcf.ucam.org>
References: <1249007138-27354-1-git-send-email-mjg@redhat.com> <4A72EF60.1090501@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A72EF60.1090501@tpi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 07:19:28AM -0600, Tim Gardner wrote:

> This works on an Inspiron 1420 and XPS1330 as far as I was able to test.
> The physical rfkill switch sets 'Hard blocked: yes' for 'phy0: Wireless
> LAN', and everything returns to normal 'blocked: no' when the switch is
> disabled. I was not able to figure out how to get BIT(16) cleared. Is
> that a keyboard function? Anyways,

Might be Fn+F2.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
