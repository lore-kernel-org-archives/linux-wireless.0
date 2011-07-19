Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35090 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab1GSMgE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 08:36:04 -0400
Message-ID: <20110719083602.jbskoirw5ws800k4-cebfxv@webmail.spamcop.net> (sfid-20110719_143609_068744_235AD5FE)
Date: Tue, 19 Jul 2011 08:36:02 -0400
From: Pavel Roskin <proski@gnu.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Franky Lin <frankyl@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/19] staging: brcm80211: remove code for unsupported
	chip
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
	<1310999405-10062-13-git-send-email-arend@broadcom.com>
	<20110718194215.GD4010@shale.localdomain> <4E24A313.3080800@broadcom.com>
	<4E24A6E3.8070700@gnu.org> <20110719054430.GE4010@shale.localdomain>
In-Reply-To: <20110719054430.GE4010@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <error27@gmail.com>:

> This commit doesn't break anything.  He explained that.
> brcmf_mmc_suspend is already initialized to false here because it is
> a static variable.

Sorry, I misinterpreted "doesn't break anything" as "doesn't cause  
compiler errors or warnings".

-- 
Regards,
Pavel Roskin
