Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:36663 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYIKMAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 08:00:13 -0400
Date: Thu, 11 Sep 2008 13:00:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>, furlot@free.fr
Subject: Re: Compaq laptop RFKILL problems
Message-ID: <20080911120002.GA1387@srcf.ucam.org> (sfid-20080911_140018_033837_82E4290A)
References: <48C80241.4000409@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48C80241.4000409@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 12:22:09PM -0500, Larry Finger wrote:
> I'm trying to help a Ubuntu user get his BCM4303 working on a Compaq 
> Presario R3215. His radio is hardware disabled, but the RFKILL switch 
> does not issue a scancode when pushed. Obviously, the Windows software 
> polls that key in some manner, but we have no idea what it does.

Can you try the hp-wmi driver?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
