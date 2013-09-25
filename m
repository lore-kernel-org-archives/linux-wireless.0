Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44906 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3IYKj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:39:58 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so2254144bkb.29
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 03:39:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380101891-18312-13-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-13-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 25 Sep 2013 12:39:57 +0200
Message-ID: <CA+BoTQndK8X==vsCJ0d3dwKc-6wAQyT2j138tnZxtOzw9siK+g@mail.gmail.com> (sfid-20130925_124001_968453_CABACD0D)
Subject: Re: [PATCH 12/13] ath10k: introduce dynamic pdev parameters
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2013 11:38, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:
> +struct wmi_pdev_param_map {
> +       u32 wmi_pdev_param_tx_chain_mask;
> +       u32 wmi_pdev_param_rx_chain_mask;
> +       u32 wmi_pdev_param_txpower_limit2g;
> +       u32 wmi_pdev_param_txpower_limit5g;
> +       u32 wmi_pdev_param_txpower_scale;
> +       u32 wmi_pdev_param_beacon_gen_mode;
> +       u32 wmi_pdev_param_beacon_tx_mode;
> +       u32 wmi_pdev_param_resmgr_offchan_mode;
> +       u32 wmi_pdev_param_protection_mode;
> +       u32 wmi_pdev_param_dynamic_bw;
> +       u32 wmi_pdev_param_non_agg_sw_retry_th;
> +       u32 wmi_pdev_param_agg_sw_retry_th;
> +       u32 wmi_pdev_param_sta_kickout_th;
> +       u32 wmi_pdev_param_ac_aggrsize_scaling;
> +       u32 wmi_pdev_param_ltr_enable;
> +       u32 wmi_pdev_param_ltr_ac_latency_be;
> +       u32 wmi_pdev_param_ltr_ac_latency_bk;
> +       u32 wmi_pdev_param_ltr_ac_latency_vi;
> +       u32 wmi_pdev_param_ltr_ac_latency_vo;
> +       u32 wmi_pdev_param_ltr_ac_latency_timeout;
> +       u32 wmi_pdev_param_ltr_sleep_override;
> +       u32 wmi_pdev_param_ltr_rx_override;
> +       u32 wmi_pdev_param_ltr_tx_activity_timeout;
> +       u32 wmi_pdev_param_l1ss_enable;
> +       u32 wmi_pdev_param_dsleep_enable;
> +       u32 wmi_pdev_param_pcielp_txbuf_flush;
> +       u32 wmi_pdev_param_pcielp_txbuf_watermark;
> +       u32 wmi_pdev_param_pcielp_txbuf_tmo_en;
> +       u32 wmi_pdev_param_pcielp_txbuf_tmo_value;
> +       u32 wmi_pdev_param_pdev_stats_update_period;
> +       u32 wmi_pdev_param_vdev_stats_update_period;
> +       u32 wmi_pdev_param_peer_stats_update_period;
> +       u32 wmi_pdev_param_bcnflt_stats_update_period;
> +       u32 wmi_pdev_param_pmf_qos;
> +       u32 wmi_pdev_param_arp_ac_override;
> +       u32 wmi_pdev_param_arpdhcp_ac_override;
> +       u32 wmi_pdev_param_dcs;
> +       u32 wmi_pdev_param_ani_enable;
> +       u32 wmi_pdev_param_ani_poll_period;
> +       u32 wmi_pdev_param_ani_listen_period;
> +       u32 wmi_pdev_param_ani_ofdm_level;
> +       u32 wmi_pdev_param_ani_cck_level;
> +       u32 wmi_pdev_param_dyntxchain;
> +       u32 wmi_pdev_param_proxy_sta;
> +       u32 wmi_pdev_param_idle_ps_config;
> +       u32 wmi_pdev_param_power_gating_sleep;
> +       u32 wmi_pdev_param_fast_channel_reset;
> +       u32 wmi_pdev_param_burst_dur;
> +       u32 wmi_pdev_param_burst_enable;

Same as per vdev_param patch. I think there's no need for the
extraneous `wmi_pdev_param_`.


Michał.
