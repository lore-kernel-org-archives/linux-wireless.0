Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53832 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbcDZJ1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:27:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/16] rtl8xxxu: Rename rtl8723bu_update_rate_mask()
 tortl8xxxu_gen2_update_rate_mask()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460994576-24091-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160426092733.29C10601A1@smtp.codeaurora.org> (sfid-20160426_112738_263884_BC32DAEE)
Date: Tue, 26 Apr 2016 09:27:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Update the name of rtl8723bu_update_rate_mask() to make it reflect
> it's applicable for all/most gen2 N parts.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 16 patches applied to wireless-drivers-next.git:

a8c8dfa59319 rtl8xxxu: Rename rtl8723bu_update_rate_mask() to rtl8xxxu_gen2_update_rate_mask()
32353a784f43 rtl8xxxu: Rename rtl8723bu_report_connect() to rtl8xxxu_gen2_report_connect()
beb5531619c6 rtl8xxxu: Rename rtl8723au_report_connect() to rtl8xxxu_gen1_report_connect()
3a56bf6aa13c rtl8xxxu: Rename rtl8723bu_config_channel() to rtl8xxxu_gen2_config_channel()
6a07b7915afe rtl8xxxu: Rename rtl8723b_disable_rf() to rtl8xxxu_gen2_disable_rf()
7eb1400c2479 rtl8xxxu: Rename rtl8723a_disable_rf() to rtl8xxxu_gen1_disable_rf()
e09718c2fddf rtl8xxxu: Rename rtl8723au_config_channel() to rtl8xxxu_gen1_config_channel()
c6e39da02e17 rtl8xxxu: Rename rtl8723au_update_rate_mask() to rtl8xxxu_update_rate_mask()
28466e921402 rtl8xxxu: Rename rtl8723au_phy_iq_calibrate() to rtl8xxxu_gen1_phy_iq_calibrate()
de7c189c342d rtl8xxxu: Rename rtl8723au_init_phy_bb() to rtl8xxxu_gen1_init_phy_bb()
42a3bc7a2a85 rtl8xxxu: Rename rtl8723a_set_tx_power() to rtl8xxxu_gen1_set_tx_power()
8396a41cf747 rtl8xxxu: Rename rtl8723a_enable_rf() to rtl8xxxu_gen1_enable_rf()
8db71451e5c4 rtl8xxxu: Rename rtl8723a_mac_init_table to rtl8xxxu_gen1_mac_init_table
5ac74145487d rtl8xxxu: Rename rtl8723b_channel_to_group()
85f466350abf rtl8xxxu: Rename rtl8723bu_simularity_compare()
04a74a9f8af0 rtl8xxxu: Rename rtl8723au_iqk_phy_iq_bb_reg

Kalle Valo
