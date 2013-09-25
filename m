Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50616 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3IYKiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:38:50 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so2199706bkh.12
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 03:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380101891-18312-12-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-12-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 25 Sep 2013 12:38:48 +0200
Message-ID: <CA+BoTQnTvSacJJ+TJ1WZgOG275=g5mcKfD6QynFkgD1GFVQG1A@mail.gmail.com> (sfid-20130925_123856_328829_FD51A6EA)
Subject: Re: [PATCH 11/13] ath10k: introduce dynamic vdev parameters
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2013 11:38, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:
> +struct wmi_vdev_param_map {
> +       u32 wmi_vdev_param_rts_threshold;
> +       u32 wmi_vdev_param_fragmentation_threshold;
> +       u32 wmi_vdev_param_beacon_interval;
> +       u32 wmi_vdev_param_listen_interval;
> +       u32 wmi_vdev_param_multicast_rate;
> +       u32 wmi_vdev_param_mgmt_tx_rate;
> +       u32 wmi_vdev_param_slot_time;
> +       u32 wmi_vdev_param_preamble;
> +       u32 wmi_vdev_param_swba_time;
> +       u32 wmi_vdev_stats_update_period;
> +       u32 wmi_vdev_pwrsave_ageout_time;
> +       u32 wmi_vdev_host_swba_interval;
> +       u32 wmi_vdev_param_dtim_period;
> +       u32 wmi_vdev_oc_scheduler_air_time_limit;
> +       u32 wmi_vdev_param_wds;
> +       u32 wmi_vdev_param_atim_window;
> +       u32 wmi_vdev_param_bmiss_count_max;
> +       u32 wmi_vdev_param_bmiss_first_bcnt;
> +       u32 wmi_vdev_param_bmiss_final_bcnt;
> +       u32 wmi_vdev_param_feature_wmm;
> +       u32 wmi_vdev_param_chwidth;
> +       u32 wmi_vdev_param_chextoffset;
> +       u32 wmi_vdev_param_disable_htprotection;
> +       u32 wmi_vdev_param_sta_quickkickout;
> +       u32 wmi_vdev_param_mgmt_rate;
> +       u32 wmi_vdev_param_protection_mode;
> +       u32 wmi_vdev_param_fixed_rate;
> +       u32 wmi_vdev_param_sgi;
> +       u32 wmi_vdev_param_ldpc;
> +       u32 wmi_vdev_param_tx_stbc;
> +       u32 wmi_vdev_param_rx_stbc;
> +       u32 wmi_vdev_param_intra_bss_fwd;
> +       u32 wmi_vdev_param_def_keyid;
> +       u32 wmi_vdev_param_nss;
> +       u32 wmi_vdev_param_bcast_data_rate;
> +       u32 wmi_vdev_param_mcast_data_rate;
> +       u32 wmi_vdev_param_mcast_indicate;
> +       u32 wmi_vdev_param_dhcp_indicate;
> +       u32 wmi_vdev_param_unknown_dest_indicate;
> +       u32 wmi_vdev_param_ap_keepalive_min_idle_inactive_time_secs;
> +       u32 wmi_vdev_param_ap_keepalive_max_idle_inactive_time_secs;
> +       u32 wmi_vdev_param_ap_keepalive_max_unresponsive_time_secs;
> +       u32 wmi_vdev_param_ap_enable_nawds;
> +       u32 wmi_vdev_param_mcast2ucast_set;
> +       u32 wmi_vdev_param_enable_rtscts;
> +       u32 wmi_vdev_param_txbf;
> +       u32 wmi_vdev_param_packet_powersave;
> +       u32 wmi_vdev_param_drop_unencry;
> +       u32 wmi_vdev_param_tx_encap_type;
> +       u32 wmi_vdev_param_ap_detect_out_of_sync_sleeping_sta_time_secs;

I don't think `wmi_vdev_param_` prefix is necessary here. Structure
already provides a prefix on it's own.


Michał.
