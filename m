Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33032 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1FCRfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 13:35:50 -0400
Received: by qwk3 with SMTP id 3so918751qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 10:35:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 3 Jun 2011 19:35:29 +0200
Message-ID: <BANLkTinvcXHMqBB4V1OBNcoacbocLfbz5g@mail.gmail.com> (sfid-20110603_193553_456051_66A14609)
Subject: Re: [ipw3945-devel] [PATCH 0/5] update for 3.0.1
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"3.0.1"? You mean Linux 3.1?

On Fri, Jun 3, 2011 at 4:54 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> We do more cleanup works for iwlagn driver
>
> Wey-Yi Guy (5):
>  iwlagn: save the latest smps mode
>  iwlagn: set smps mode after assoc for 1000 device
>  iwlagn: move all post scan functions in one place
>  iwlagn: direct call to post_scan function
>  iwlagn: call commit_rxon function directly
>
> these patches are also available from wireless-next-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
>
>  drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
>  drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    3 ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
>  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   17 +++++++++++++++++
>  drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++++-----
>  drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-core.h     |   13 ++++---------
>  drivers/net/wireless/iwlwifi/iwl-scan.c     |   10 ++--------
>  8 files changed, 31 insertions(+), 26 deletions(-)
>
>
> ------------------------------------------------------------------------------
> Simplify data backup and recovery for your virtual environment with vRanger.
> Installation's a snap, and flexible recovery options mean your data is safe,
> secure and there when you need it. Discover what all the cheering's about.
> Get your free trial download today.
> http://p.sf.net/sfu/quest-dev2dev2
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
