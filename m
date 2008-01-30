Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:28073 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYA3JUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 04:20:11 -0500
Received: by py-out-1112.google.com with SMTP id u52so267241pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2008 01:20:10 -0800 (PST)
Message-ID: <43e72e890801300120kd14affew4af1f4904028f43f@mail.gmail.com> (sfid-20080130_092025_727694_F76368FC)
Date: Wed, 30 Jan 2008 04:20:10 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Reinette Chatre" <reinette.chatre@intel.com>
Subject: Re: [PATCH] compat-2.6: enable install on clean system
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1201653653-1560-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1201653653-1560-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 29, 2008 7:40 PM, Reinette Chatre <reinette.chatre@intel.com> wrote:
> "make install" depends on "uninstall". When "make install" is run for the first
> time the scripts athenable and b43enable have not yet been placed in their expected
> location (/usr/sbin). This causes the build to fail when uninstall tries to use these
> scripts.
>
> Change the uninstall rule to only use these scripts if they exist in their expected
> location.
>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Applied, thanks. Also made updates to account for rndis_wext -->
rndis_wlan rename.

  Luis
