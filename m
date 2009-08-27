Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:51002 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZH0P23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 11:28:29 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu\, Yi" <yi.zhu@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: show_version() displays confusing/wrong firmware version
References: <1251379989-20728-1-git-send-email-bjorn@mork.no>
	<1251385041.3805.17.camel@rc-desk>
Date: Thu, 27 Aug 2009 17:09:05 +0200
In-Reply-To: <1251385041.3805.17.camel@rc-desk> (reinette chatre's message of
	"Thu, 27 Aug 2009 07:57:21 -0700")
Message-ID: <87r5uxb8fi.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> Hi Bjørn,
>
> Which kernel/repo is your patch based on?

Oh, sorry for not including that vital information.  I'm afraid it is
against Linus' tree at 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
and not any of the wireless/networking trees.

"git log drivers/net/wireless/iwlwifi/iwl-agn.c" shows this as the last
commit affecting iwl-agn.c before my change:

commit 872ed1902f511a8947021c562f5728a5bf0640b5
Author: Reinette Chatre <reinette.chatre@intel.com>
Date:   Thu Jul 9 10:33:37 2009 -0700

    iwlwifi: only show active power level via sysfs
    


Bjørn
