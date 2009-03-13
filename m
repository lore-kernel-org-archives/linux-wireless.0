Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f175.google.com ([209.85.218.175]:46215 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZCMU3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 16:29:21 -0400
Received: by bwz23 with SMTP id 23so257422bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 13:29:18 -0700 (PDT)
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: Re: [PATCH 1/8] iwl3945: fix sparse error
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	<1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 13 Mar 2009 22:29:15 +0200
In-Reply-To: <1236795481-12757-2-git-send-email-reinette.chatre@intel.com> (Reinette Chatre's message of "Wed\, 11 Mar 2009 11\:17\:54 -0700")
Message-ID: <87mybpmajo.fsf@litku.valot.fi> (sfid-20090313_212925_355178_AECAA9BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre <reinette.chatre@intel.com> writes:

> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>
> error is:
> iwl3945-base.c:545:5: warning: symbol 'iwl3945_set_dynamic_key' was not
> declared. Should it be static?

I would call that a warning, not an error. Not that it matters.

-- 
Kalle Valo
