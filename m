Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49785 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1GERjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 13:39:21 -0400
Received: by pzk9 with SMTP id 9so2647098pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 10:39:21 -0700 (PDT)
Date: Tue, 5 Jul 2011 20:38:17 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 061/119] staging: brcm80211: further renaming in fullmac
 sources
Message-ID: <20110705173817.GB18655@shale.localdomain> (sfid-20110705_193925_228704_EF60D81C)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-62-git-send-email-frankyl@broadcom.com>
 <20110705073615.GO2544@shale.localdomain>
 <4E131C72.4010802@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E131C72.4010802@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 05, 2011 at 04:15:14PM +0200, Roland Vossen wrote:
> Hello Dan,
> 
> I will create a patch (in the short term, couple of days) to address
> the issues you detected below. Since this patch [061/119] does not
> regress behavior, is it ok with you to *not* drop it ?
> 

Yeah.  I said that earlier, that we should just apply the whole
series as is.

These were all in the original code etc, but I there can't be a
hundred patches in a row without some complaints or it looks like
no one is reviewing.  :)

The whole series looks good by the way.

regards,
dan carpenter

