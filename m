Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64089 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbZFLLRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:17:49 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 28/33] wl1251: add wl1251 prefix to all 1251 files
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:19 +0300
Message-ID: <20090612111719.8877.40672.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Now that all 1271 files are split, we can add wl1251_ prefix to the files.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/Makefile         |    7 
 drivers/net/wireless/wl12xx/acx.c            |  841 ---------------
 drivers/net/wireless/wl12xx/acx.h            | 1146 ---------------------
 drivers/net/wireless/wl12xx/boot.c           |  297 -----
 drivers/net/wireless/wl12xx/boot.h           |   40 -
 drivers/net/wireless/wl12xx/cmd.c            |  429 --------
 drivers/net/wireless/wl12xx/cmd.h            |  407 -------
 drivers/net/wireless/wl12xx/debugfs.c        |  518 ---------
 drivers/net/wireless/wl12xx/debugfs.h        |   33 -
 drivers/net/wireless/wl12xx/event.c          |  127 --
 drivers/net/wireless/wl12xx/event.h          |  121 --
 drivers/net/wireless/wl12xx/init.c           |  200 ----
 drivers/net/wireless/wl12xx/init.h           |   40 -
 drivers/net/wireless/wl12xx/main.c           | 1442 --------------------------
 drivers/net/wireless/wl12xx/ps.c             |  147 ---
 drivers/net/wireless/wl12xx/ps.h             |   36 -
 drivers/net/wireless/wl12xx/rx.c             |  194 ---
 drivers/net/wireless/wl12xx/rx.h             |  122 --
 drivers/net/wireless/wl12xx/spi.c            |  395 -------
 drivers/net/wireless/wl12xx/spi.h            |  115 --
 drivers/net/wireless/wl12xx/wl1251_acx.c     |  841 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h     | 1146 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_boot.c    |  297 +++++
 drivers/net/wireless/wl12xx/wl1251_boot.h    |   40 +
 drivers/net/wireless/wl12xx/wl1251_cmd.c     |  429 ++++++++
 drivers/net/wireless/wl12xx/wl1251_cmd.h     |  407 +++++++
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |  518 +++++++++
 drivers/net/wireless/wl12xx/wl1251_debugfs.h |   33 +
 drivers/net/wireless/wl12xx/wl1251_event.c   |  127 ++
 drivers/net/wireless/wl12xx/wl1251_event.h   |  121 ++
 drivers/net/wireless/wl12xx/wl1251_init.c    |  200 ++++
 drivers/net/wireless/wl12xx/wl1251_init.h    |   40 +
 drivers/net/wireless/wl12xx/wl1251_main.c    | 1442 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_netlink.c |  679 ++++++++++++
 drivers/net/wireless/wl12xx/wl1251_netlink.h |   30 +
 drivers/net/wireless/wl12xx/wl1251_ops.c     |   14 
 drivers/net/wireless/wl12xx/wl1251_ops.h     |    2 
 drivers/net/wireless/wl12xx/wl1251_ps.c      |  147 +++
 drivers/net/wireless/wl12xx/wl1251_ps.h      |   36 +
 drivers/net/wireless/wl12xx/wl1251_rx.c      |  195 ++++
 drivers/net/wireless/wl12xx/wl1251_rx.h      |  122 ++
 drivers/net/wireless/wl12xx/wl1251_spi.c     |  394 +++++++
 drivers/net/wireless/wl12xx/wl1251_spi.h     |  115 ++
 drivers/net/wireless/wl12xx/wl1251_tx.c      |    4 
 44 files changed, 7373 insertions(+), 6663 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/acx.c
 delete mode 100644 drivers/net/wireless/wl12xx/acx.h
 delete mode 100644 drivers/net/wireless/wl12xx/boot.c
 delete mode 100644 drivers/net/wireless/wl12xx/boot.h
 delete mode 100644 drivers/net/wireless/wl12xx/cmd.c
 delete mode 100644 drivers/net/wireless/wl12xx/cmd.h
 delete mode 100644 drivers/net/wireless/wl12xx/debugfs.c
 delete mode 100644 drivers/net/wireless/wl12xx/debugfs.h
 delete mode 100644 drivers/net/wireless/wl12xx/event.c
 delete mode 100644 drivers/net/wireless/wl12xx/event.h
 delete mode 100644 drivers/net/wireless/wl12xx/init.c
 delete mode 100644 drivers/net/wireless/wl12xx/init.h
 delete mode 100644 drivers/net/wireless/wl12xx/main.c
 delete mode 100644 drivers/net/wireless/wl12xx/ps.c
 delete mode 100644 drivers/net/wireless/wl12xx/ps.h
 delete mode 100644 drivers/net/wireless/wl12xx/rx.c
 delete mode 100644 drivers/net/wireless/wl12xx/rx.h
 delete mode 100644 drivers/net/wireless/wl12xx/spi.c
 delete mode 100644 drivers/net/wireless/wl12xx/spi.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_acx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_acx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_boot.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_boot.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_cmd.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_cmd.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_debugfs.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_debugfs.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_event.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_event.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_init.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_init.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_main.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_netlink.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_netlink.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_ps.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_ps.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_rx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_rx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_spi.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_spi.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index f94970c..d5595a8 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,4 +1,5 @@
-wl1251-objs		= main.o spi.o event.o wl1251_tx.o rx.o \
-			  ps.o cmd.o acx.o boot.o init.o wl1251_ops.o  \
-			  debugfs.o
+wl1251-objs		= wl1251_main.o wl1251_spi.o wl1251_event.o \
+			  wl1251_tx.o wl1251_rx.o wl1251_ps.o wl1251_cmd.o \
+			  wl1251_acx.o wl1251_boot.o wl1251_init.o \
+			  wl1251_ops.o wl1251_debugfs.o
 obj-$(CONFIG_WL1251)	+= wl1251.o
diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
deleted file mode 100644
index 328f88a..0000000
--- a/drivers/net/wireless/wl12xx/acx.c
+++ /dev/null
@@ -1,841 +0,0 @@
-#include "acx.h"
-
-#include <linux/module.h>
-#include <linux/crc7.h>
-#include <linux/spi/spi.h>
-
-#include "wl12xx.h"
-#include "wl12xx_80211.h"
-#include "reg.h"
-#include "spi.h"
-#include "ps.h"
-
-int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
-			   u8 mgt_rate, u8 mgt_mod)
-{
-	struct acx_fw_gen_frame_rates *rates;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx frame rates");
-
-	rates = kzalloc(sizeof(*rates), GFP_KERNEL);
-	if (!rates) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	rates->tx_ctrl_frame_rate = ctrl_rate;
-	rates->tx_ctrl_frame_mod = ctrl_mod;
-	rates->tx_mgt_frame_rate = mgt_rate;
-	rates->tx_mgt_frame_mod = mgt_mod;
-
-	ret = wl12xx_cmd_configure(wl, ACX_FW_GEN_FRAME_RATES,
-				   rates, sizeof(*rates));
-	if (ret < 0) {
-		wl12xx_error("Failed to set FW rates and modulation");
-		goto out;
-	}
-
-out:
-	kfree(rates);
-	return ret;
-}
-
-
-int wl12xx_acx_station_id(struct wl12xx *wl)
-{
-	struct acx_dot11_station_id *mac;
-	int ret, i;
-
-	wl12xx_debug(DEBUG_ACX, "acx dot11_station_id");
-
-	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
-	if (!mac) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	for (i = 0; i < ETH_ALEN; i++)
-		mac->mac[i] = wl->mac_addr[ETH_ALEN - 1 - i];
-
-	ret = wl12xx_cmd_configure(wl, DOT11_STATION_ID, mac, sizeof(*mac));
-	if (ret < 0)
-		goto out;
-
-out:
-	kfree(mac);
-	return ret;
-}
-
-int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id)
-{
-	struct acx_dot11_default_key *default_key;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx dot11_default_key (%d)", key_id);
-
-	default_key = kzalloc(sizeof(*default_key), GFP_KERNEL);
-	if (!default_key) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	default_key->id = key_id;
-
-	ret = wl12xx_cmd_configure(wl, DOT11_DEFAULT_KEY,
-				   default_key, sizeof(*default_key));
-	if (ret < 0) {
-		wl12xx_error("Couldnt set default key");
-		goto out;
-	}
-
-	wl->default_key = key_id;
-
-out:
-	kfree(default_key);
-	return ret;
-}
-
-int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
-				  u8 listen_interval)
-{
-	struct acx_wake_up_condition *wake_up;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx wake up conditions");
-
-	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
-	if (!wake_up) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	wake_up->wake_up_event = wake_up_event;
-	wake_up->listen_interval = listen_interval;
-
-	ret = wl12xx_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
-				   wake_up, sizeof(*wake_up));
-	if (ret < 0) {
-		wl12xx_warning("could not set wake up conditions: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(wake_up);
-	return ret;
-}
-
-int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth)
-{
-	struct acx_sleep_auth *auth;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx sleep auth");
-
-	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
-	if (!auth) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	auth->sleep_auth = sleep_auth;
-
-	ret = wl12xx_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
-	if (ret < 0)
-		return ret;
-
-out:
-	kfree(auth);
-	return ret;
-}
-
-int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len)
-{
-	struct acx_revision *rev;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx fw rev");
-
-	rev = kzalloc(sizeof(*rev), GFP_KERNEL);
-	if (!rev) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = wl12xx_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
-	if (ret < 0) {
-		wl12xx_warning("ACX_FW_REV interrogate failed");
-		goto out;
-	}
-
-	/* be careful with the buffer sizes */
-	strncpy(buf, rev->fw_version, min(len, sizeof(rev->fw_version)));
-
-	/*
-	 * if the firmware version string is exactly
-	 * sizeof(rev->fw_version) long or fw_len is less than
-	 * sizeof(rev->fw_version) it won't be null terminated
-	 */
-	buf[min(len, sizeof(rev->fw_version)) - 1] = '\0';
-
-out:
-	kfree(rev);
-	return ret;
-}
-
-int wl12xx_acx_tx_power(struct wl12xx *wl, int power)
-{
-	struct acx_current_tx_power *acx;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
-
-	if (power < 0 || power > 25)
-		return -EINVAL;
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	acx->current_tx_power = power * 10;
-
-	ret = wl12xx_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl12xx_warning("configure of tx power failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
-int wl12xx_acx_feature_cfg(struct wl12xx *wl)
-{
-	struct acx_feature_config *feature;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx feature cfg");
-
-	feature = kzalloc(sizeof(*feature), GFP_KERNEL);
-	if (!feature) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
-	feature->data_flow_options = 0;
-	feature->options = 0;
-
-	ret = wl12xx_cmd_configure(wl, ACX_FEATURE_CFG,
-				   feature, sizeof(*feature));
-	if (ret < 0) {
-		wl12xx_error("Couldnt set HW encryption");
-		goto out;
-	}
-
-out:
-	kfree(feature);
-	return ret;
-}
-
-int wl12xx_acx_mem_map(struct wl12xx *wl, struct acx_header *mem_map,
-		       size_t len)
-{
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx mem map");
-
-	ret = wl12xx_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_acx_data_path_params(struct wl12xx *wl,
-				struct acx_data_path_params_resp *resp)
-{
-	struct acx_data_path_params *params;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx data path params");
-
-	params = kzalloc(sizeof(*params), GFP_KERNEL);
-	if (!params) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	params->rx_packet_ring_chunk_size = DP_RX_PACKET_RING_CHUNK_SIZE;
-	params->tx_packet_ring_chunk_size = DP_TX_PACKET_RING_CHUNK_SIZE;
-
-	params->rx_packet_ring_chunk_num = DP_RX_PACKET_RING_CHUNK_NUM;
-	params->tx_packet_ring_chunk_num = DP_TX_PACKET_RING_CHUNK_NUM;
-
-	params->tx_complete_threshold = 1;
-
-	params->tx_complete_ring_depth = FW_TX_CMPLT_BLOCK_SIZE;
-
-	params->tx_complete_timeout = DP_TX_COMPLETE_TIME_OUT;
-
-	ret = wl12xx_cmd_configure(wl, ACX_DATA_PATH_PARAMS,
-				   params, sizeof(*params));
-	if (ret < 0)
-		goto out;
-
-	/* FIXME: shouldn't this be ACX_DATA_PATH_RESP_PARAMS? */
-	ret = wl12xx_cmd_interrogate(wl, ACX_DATA_PATH_PARAMS,
-				     resp, sizeof(*resp));
-
-	if (ret < 0) {
-		wl12xx_warning("failed to read data path parameters: %d", ret);
-		goto out;
-	} else if (resp->header.cmd.status != CMD_STATUS_SUCCESS) {
-		wl12xx_warning("data path parameter acx status failed");
-		ret = -EIO;
-		goto out;
-	}
-
-out:
-	kfree(params);
-	return ret;
-}
-
-int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time)
-{
-	struct acx_rx_msdu_lifetime *acx;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx rx msdu life time");
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	acx->lifetime = life_time;
-	ret = wl12xx_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
-				   acx, sizeof(*acx));
-	if (ret < 0) {
-		wl12xx_warning("failed to set rx msdu life time: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
-int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter)
-{
-	struct acx_rx_config *rx_config;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx rx config");
-
-	rx_config = kzalloc(sizeof(*rx_config), GFP_KERNEL);
-	if (!rx_config) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	rx_config->config_options = config;
-	rx_config->filter_options = filter;
-
-	ret = wl12xx_cmd_configure(wl, ACX_RX_CFG,
-				   rx_config, sizeof(*rx_config));
-	if (ret < 0) {
-		wl12xx_warning("failed to set rx config: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(rx_config);
-	return ret;
-}
-
-int wl12xx_acx_pd_threshold(struct wl12xx *wl)
-{
-	struct acx_packet_detection *pd;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx data pd threshold");
-
-	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* FIXME: threshold value not set */
-
-	ret = wl12xx_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
-	if (ret < 0) {
-		wl12xx_warning("failed to set pd threshold: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(pd);
-	return 0;
-}
-
-int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time)
-{
-	struct acx_slot *slot;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx slot");
-
-	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
-	if (!slot) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	slot->wone_index = STATION_WONE_INDEX;
-	slot->slot_time = slot_time;
-
-	ret = wl12xx_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
-	if (ret < 0) {
-		wl12xx_warning("failed to set slot time: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(slot);
-	return ret;
-}
-
-int wl12xx_acx_group_address_tbl(struct wl12xx *wl)
-{
-	struct acx_dot11_grp_addr_tbl *acx;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx group address tbl");
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* MAC filtering */
-	acx->enabled = 0;
-	acx->num_groups = 0;
-	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
-
-	ret = wl12xx_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
-				   acx, sizeof(*acx));
-	if (ret < 0) {
-		wl12xx_warning("failed to set group addr table: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
-int wl12xx_acx_service_period_timeout(struct wl12xx *wl)
-{
-	struct acx_rx_timeout *rx_timeout;
-	int ret;
-
-	rx_timeout = kzalloc(sizeof(*rx_timeout), GFP_KERNEL);
-	if (!rx_timeout) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	wl12xx_debug(DEBUG_ACX, "acx service period timeout");
-
-	rx_timeout->ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
-	rx_timeout->upsd_timeout = RX_TIMEOUT_UPSD_DEF;
-
-	ret = wl12xx_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
-				   rx_timeout, sizeof(*rx_timeout));
-	if (ret < 0) {
-		wl12xx_warning("failed to set service period timeout: %d",
-			       ret);
-		goto out;
-	}
-
-out:
-	kfree(rx_timeout);
-	return ret;
-}
-
-int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold)
-{
-	struct acx_rts_threshold *rts;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx rts threshold");
-
-	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
-	if (!rts) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	rts->threshold = rts_threshold;
-
-	ret = wl12xx_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
-	if (ret < 0) {
-		wl12xx_warning("failed to set rts threshold: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(rts);
-	return ret;
-}
-
-int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl)
-{
-	struct acx_beacon_filter_option *beacon_filter;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx beacon filter opt");
-
-	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
-	if (!beacon_filter) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	beacon_filter->enable = 0;
-	beacon_filter->max_num_beacons = 0;
-
-	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
-				   beacon_filter, sizeof(*beacon_filter));
-	if (ret < 0) {
-		wl12xx_warning("failed to set beacon filter opt: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(beacon_filter);
-	return ret;
-}
-
-int wl12xx_acx_beacon_filter_table(struct wl12xx *wl)
-{
-	struct acx_beacon_filter_ie_table *ie_table;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx beacon filter table");
-
-	ie_table = kzalloc(sizeof(*ie_table), GFP_KERNEL);
-	if (!ie_table) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ie_table->num_ie = 0;
-	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
-
-	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
-				   ie_table, sizeof(*ie_table));
-	if (ret < 0) {
-		wl12xx_warning("failed to set beacon filter table: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(ie_table);
-	return ret;
-}
-
-int wl12xx_acx_sg_enable(struct wl12xx *wl)
-{
-	struct acx_bt_wlan_coex *pta;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx sg enable");
-
-	pta = kzalloc(sizeof(*pta), GFP_KERNEL);
-	if (!pta) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	pta->enable = SG_ENABLE;
-
-	ret = wl12xx_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
-	if (ret < 0) {
-		wl12xx_warning("failed to set softgemini enable: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(pta);
-	return ret;
-}
-
-int wl12xx_acx_sg_cfg(struct wl12xx *wl)
-{
-	struct acx_bt_wlan_coex_param *param;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx sg cfg");
-
-	param = kzalloc(sizeof(*param), GFP_KERNEL);
-	if (!param) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* BT-WLAN coext parameters */
-	param->min_rate = RATE_INDEX_24MBPS;
-	param->bt_hp_max_time = PTA_BT_HP_MAXTIME_DEF;
-	param->wlan_hp_max_time = PTA_WLAN_HP_MAX_TIME_DEF;
-	param->sense_disable_timer = PTA_SENSE_DISABLE_TIMER_DEF;
-	param->rx_time_bt_hp = PTA_PROTECTIVE_RX_TIME_DEF;
-	param->tx_time_bt_hp = PTA_PROTECTIVE_TX_TIME_DEF;
-	param->rx_time_bt_hp_fast = PTA_PROTECTIVE_RX_TIME_FAST_DEF;
-	param->tx_time_bt_hp_fast = PTA_PROTECTIVE_TX_TIME_FAST_DEF;
-	param->wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
-	param->bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
-	param->next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
-	param->wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
-	param->hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
-	param->next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
-	param->antenna_type = PTA_ANTENNA_TYPE_DEF;
-	param->signal_type = PTA_SIGNALING_TYPE_DEF;
-	param->afh_leverage_on = PTA_AFH_LEVERAGE_ON_DEF;
-	param->quiet_cycle_num = PTA_NUMBER_QUIET_CYCLE_DEF;
-	param->max_cts = PTA_MAX_NUM_CTS_DEF;
-	param->wlan_packets_num = PTA_NUMBER_OF_WLAN_PACKETS_DEF;
-	param->bt_packets_num = PTA_NUMBER_OF_BT_PACKETS_DEF;
-	param->missed_rx_avalanche = PTA_RX_FOR_AVALANCHE_DEF;
-	param->wlan_elp_hp = PTA_ELP_HP_DEF;
-	param->bt_anti_starvation_cycles = PTA_ANTI_STARVE_NUM_CYCLE_DEF;
-	param->ack_mode_dual_ant = PTA_ACK_MODE_DEF;
-	param->pa_sd_enable = PTA_ALLOW_PA_SD_DEF;
-	param->pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
-	param->bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
-
-	ret = wl12xx_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
-	if (ret < 0) {
-		wl12xx_warning("failed to set sg config: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(param);
-	return ret;
-}
-
-int wl12xx_acx_cca_threshold(struct wl12xx *wl)
-{
-	struct acx_energy_detection *detection;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx cca threshold");
-
-	detection = kzalloc(sizeof(*detection), GFP_KERNEL);
-	if (!detection) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	detection->rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
-	detection->tx_energy_detection = 0;
-
-	ret = wl12xx_cmd_configure(wl, ACX_CCA_THRESHOLD,
-				   detection, sizeof(*detection));
-	if (ret < 0) {
-		wl12xx_warning("failed to set cca threshold: %d", ret);
-		return ret;
-	}
-
-out:
-	kfree(detection);
-	return ret;
-}
-
-int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl)
-{
-	struct acx_beacon_broadcast *bb;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx bcn dtim options");
-
-	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
-	if (!bb) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	bb->beacon_rx_timeout = BCN_RX_TIMEOUT_DEF_VALUE;
-	bb->broadcast_timeout = BROADCAST_RX_TIMEOUT_DEF_VALUE;
-	bb->rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
-	bb->ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
-
-	ret = wl12xx_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
-	if (ret < 0) {
-		wl12xx_warning("failed to set rx config: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(bb);
-	return ret;
-}
-
-int wl12xx_acx_aid(struct wl12xx *wl, u16 aid)
-{
-	struct acx_aid *acx_aid;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx aid");
-
-	acx_aid = kzalloc(sizeof(*acx_aid), GFP_KERNEL);
-	if (!acx_aid) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	acx_aid->aid = aid;
-
-	ret = wl12xx_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
-	if (ret < 0) {
-		wl12xx_warning("failed to set aid: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx_aid);
-	return ret;
-}
-
-int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask)
-{
-	struct acx_event_mask *mask;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx event mbox mask");
-
-	mask = kzalloc(sizeof(*mask), GFP_KERNEL);
-	if (!mask) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* high event mask is unused */
-	mask->high_event_mask = 0xffffffff;
-
-	mask->event_mask = event_mask;
-
-	ret = wl12xx_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
-				   mask, sizeof(*mask));
-	if (ret < 0) {
-		wl12xx_warning("failed to set acx_event_mbox_mask: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(mask);
-	return ret;
-}
-
-int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble)
-{
-	struct acx_preamble *acx;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx_set_preamble");
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	acx->preamble = preamble;
-
-	ret = wl12xx_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl12xx_warning("Setting of preamble failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
-int wl12xx_acx_cts_protect(struct wl12xx *wl,
-			   enum acx_ctsprotect_type ctsprotect)
-{
-	struct acx_ctsprotect *acx;
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx_set_ctsprotect");
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	acx->ctsprotect = ctsprotect;
-
-	ret = wl12xx_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl12xx_warning("Setting of ctsprotect failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
-int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime)
-{
-	struct acx_tsf_info *tsf_info;
-	int ret;
-
-	tsf_info = kzalloc(sizeof(*tsf_info), GFP_KERNEL);
-	if (!tsf_info) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = wl12xx_cmd_interrogate(wl, ACX_TSF_INFO,
-				     tsf_info, sizeof(*tsf_info));
-	if (ret < 0) {
-		wl12xx_warning("ACX_FW_REV interrogate failed");
-		goto out;
-	}
-
-	*mactime = tsf_info->current_tsf_lsb |
-		(tsf_info->current_tsf_msb << 31);
-
-out:
-	kfree(tsf_info);
-	return ret;
-}
-
-int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats)
-{
-	int ret;
-
-	wl12xx_debug(DEBUG_ACX, "acx statistics");
-
-	ret = wl12xx_cmd_interrogate(wl, ACX_STATISTICS, stats,
-				     sizeof(*stats));
-	if (ret < 0) {
-		wl12xx_warning("acx statistics failed: %d", ret);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
deleted file mode 100644
index 92e7248..0000000
--- a/drivers/net/wireless/wl12xx/acx.h
+++ /dev/null
@@ -1,1146 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_ACX_H__
-#define __WL12XX_ACX_H__
-
-#include "wl12xx.h"
-#include "cmd.h"
-
-/* Target's information element */
-struct acx_header {
-	struct wl12xx_cmd_header cmd;
-
-	/* acx (or information element) header */
-	u16 id;
-
-	/* payload length (not including headers */
-	u16 len;
-};
-
-struct acx_error_counter {
-	struct acx_header header;
-
-	/* The number of PLCP errors since the last time this */
-	/* information element was interrogated. This field is */
-	/* automatically cleared when it is interrogated.*/
-	u32 PLCP_error;
-
-	/* The number of FCS errors since the last time this */
-	/* information element was interrogated. This field is */
-	/* automatically cleared when it is interrogated.*/
-	u32 FCS_error;
-
-	/* The number of MPDUs without PLCP header errors received*/
-	/* since the last time this information element was interrogated. */
-	/* This field is automatically cleared when it is interrogated.*/
-	u32 valid_frame;
-
-	/* the number of missed sequence numbers in the squentially */
-	/* values of frames seq numbers */
-	u32 seq_num_miss;
-} __attribute__ ((packed));
-
-struct acx_revision {
-	struct acx_header header;
-
-	/*
-	 * The WiLink firmware version, an ASCII string x.x.x.x,
-	 * that uniquely identifies the current firmware.
-	 * The left most digit is incremented each time a
-	 * significant change is made to the firmware, such as
-	 * code redesign or new platform support.
-	 * The second digit is incremented when major enhancements
-	 * are added or major fixes are made.
-	 * The third digit is incremented for each GA release.
-	 * The fourth digit is incremented for each build.
-	 * The first two digits identify a firmware release version,
-	 * in other words, a unique set of features.
-	 * The first three digits identify a GA release.
-	 */
-	char fw_version[20];
-
-	/*
-	 * This 4 byte field specifies the WiLink hardware version.
-	 * bits 0  - 15: Reserved.
-	 * bits 16 - 23: Version ID - The WiLink version ID
-	 *              (1 = first spin, 2 = second spin, and so on).
-	 * bits 24 - 31: Chip ID - The WiLink chip ID.
-	 */
-	u32 hw_version;
-} __attribute__ ((packed));
-
-enum wl12xx_psm_mode {
-	/* Active mode */
-	WL12XX_PSM_CAM = 0,
-
-	/* Power save mode */
-	WL12XX_PSM_PS = 1,
-
-	/* Extreme low power */
-	WL12XX_PSM_ELP = 2,
-};
-
-struct acx_sleep_auth {
-	struct acx_header header;
-
-	/* The sleep level authorization of the device. */
-	/* 0 - Always active*/
-	/* 1 - Power down mode: light / fast sleep*/
-	/* 2 - ELP mode: Deep / Max sleep*/
-	u8  sleep_auth;
-	u8  padding[3];
-} __attribute__ ((packed));
-
-enum {
-	HOSTIF_PCI_MASTER_HOST_INDIRECT,
-	HOSTIF_PCI_MASTER_HOST_DIRECT,
-	HOSTIF_SLAVE,
-	HOSTIF_PKT_RING,
-	HOSTIF_DONTCARE = 0xFF
-};
-
-#define DEFAULT_UCAST_PRIORITY          0
-#define DEFAULT_RX_Q_PRIORITY           0
-#define DEFAULT_NUM_STATIONS            1
-#define DEFAULT_RXQ_PRIORITY            0 /* low 0 .. 15 high  */
-#define DEFAULT_RXQ_TYPE                0x07    /* All frames, Data/Ctrl/Mgmt */
-#define TRACE_BUFFER_MAX_SIZE           256
-
-#define  DP_RX_PACKET_RING_CHUNK_SIZE 1600
-#define  DP_TX_PACKET_RING_CHUNK_SIZE 1600
-#define  DP_RX_PACKET_RING_CHUNK_NUM 2
-#define  DP_TX_PACKET_RING_CHUNK_NUM 2
-#define  DP_TX_COMPLETE_TIME_OUT 20
-#define  FW_TX_CMPLT_BLOCK_SIZE 16
-
-struct acx_data_path_params {
-	struct acx_header header;
-
-	u16 rx_packet_ring_chunk_size;
-	u16 tx_packet_ring_chunk_size;
-
-	u8 rx_packet_ring_chunk_num;
-	u8 tx_packet_ring_chunk_num;
-
-	/*
-	 * Maximum number of packets that can be gathered
-	 * in the TX complete ring before an interrupt
-	 * is generated.
-	 */
-	u8 tx_complete_threshold;
-
-	/* Number of pending TX complete entries in cyclic ring.*/
-	u8 tx_complete_ring_depth;
-
-	/*
-	 * Max num microseconds since a packet enters the TX
-	 * complete ring until an interrupt is generated.
-	 */
-	u32 tx_complete_timeout;
-} __attribute__ ((packed));
-
-
-struct acx_data_path_params_resp {
-	struct acx_header header;
-
-	u16 rx_packet_ring_chunk_size;
-	u16 tx_packet_ring_chunk_size;
-
-	u8 rx_packet_ring_chunk_num;
-	u8 tx_packet_ring_chunk_num;
-
-	u8 pad[2];
-
-	u32 rx_packet_ring_addr;
-	u32 tx_packet_ring_addr;
-
-	u32 rx_control_addr;
-	u32 tx_control_addr;
-
-	u32 tx_complete_addr;
-} __attribute__ ((packed));
-
-#define TX_MSDU_LIFETIME_MIN       0
-#define TX_MSDU_LIFETIME_MAX       3000
-#define TX_MSDU_LIFETIME_DEF       512
-#define RX_MSDU_LIFETIME_MIN       0
-#define RX_MSDU_LIFETIME_MAX       0xFFFFFFFF
-#define RX_MSDU_LIFETIME_DEF       512000
-
-struct acx_rx_msdu_lifetime {
-	struct acx_header header;
-
-	/*
-	 * The maximum amount of time, in TU, before the
-	 * firmware discards the MSDU.
-	 */
-	u32 lifetime;
-} __attribute__ ((packed));
-
-/*
- * RX Config Options Table
- * Bit		Definition
- * ===		==========
- * 31:14		Reserved
- * 13		Copy RX Status - when set, write three receive status words
- * 	 	to top of rx'd MPDUs.
- * 		When cleared, do not write three status words (added rev 1.5)
- * 12		Reserved
- * 11		RX Complete upon FCS error - when set, give rx complete
- *	 	interrupt for FCS errors, after the rx filtering, e.g. unicast
- *	 	frames not to us with FCS error will not generate an interrupt.
- * 10		SSID Filter Enable - When set, the WiLink discards all beacon,
- *	        probe request, and probe response frames with an SSID that does
- *		not match the SSID specified by the host in the START/JOIN
- *		command.
- *		When clear, the WiLink receives frames with any SSID.
- * 9		Broadcast Filter Enable - When set, the WiLink discards all
- * 	 	broadcast frames. When clear, the WiLink receives all received
- *		broadcast frames.
- * 8:6		Reserved
- * 5		BSSID Filter Enable - When set, the WiLink discards any frames
- * 	 	with a BSSID that does not match the BSSID specified by the
- *		host.
- *		When clear, the WiLink receives frames from any BSSID.
- * 4		MAC Addr Filter - When set, the WiLink discards any frames
- * 	 	with a destination address that does not match the MAC address
- *		of the adaptor.
- *		When clear, the WiLink receives frames destined to any MAC
- *		address.
- * 3		Promiscuous - When set, the WiLink receives all valid frames
- * 	 	(i.e., all frames that pass the FCS check).
- *		When clear, only frames that pass the other filters specified
- *		are received.
- * 2		FCS - When set, the WiLink includes the FCS with the received
- *	 	frame.
- *		When cleared, the FCS is discarded.
- * 1		PLCP header - When set, write all data from baseband to frame
- * 	 	buffer including PHY header.
- * 0		Reserved - Always equal to 0.
- *
- * RX Filter Options Table
- * Bit		Definition
- * ===		==========
- * 31:12		Reserved - Always equal to 0.
- * 11		Association - When set, the WiLink receives all association
- * 	 	related frames (association request/response, reassocation
- *		request/response, and disassociation). When clear, these frames
- *		are discarded.
- * 10		Auth/De auth - When set, the WiLink receives all authentication
- * 	 	and de-authentication frames. When clear, these frames are
- *		discarded.
- * 9		Beacon - When set, the WiLink receives all beacon frames.
- * 	 	When clear, these frames are discarded.
- * 8		Contention Free - When set, the WiLink receives all contention
- * 	 	free frames.
- *		When clear, these frames are discarded.
- * 7		Control - When set, the WiLink receives all control frames.
- * 	 	When clear, these frames are discarded.
- * 6		Data - When set, the WiLink receives all data frames.
- * 	 	When clear, these frames are discarded.
- * 5		FCS Error - When set, the WiLink receives frames that have FCS
- *	 	errors.
- *		When clear, these frames are discarded.
- * 4		Management - When set, the WiLink receives all management
- *		frames.
- * 	 	When clear, these frames are discarded.
- * 3		Probe Request - When set, the WiLink receives all probe request
- * 	 	frames.
- *		When clear, these frames are discarded.
- * 2		Probe Response - When set, the WiLink receives all probe
- * 		response frames.
- *		When clear, these frames are discarded.
- * 1		RTS/CTS/ACK - When set, the WiLink receives all RTS, CTS and ACK
- * 	 	frames.
- *		When clear, these frames are discarded.
- * 0		Rsvd Type/Sub Type - When set, the WiLink receives all frames
- * 	 	that have reserved frame types and sub types as defined by the
- *		802.11 specification.
- *		When clear, these frames are discarded.
- */
-struct acx_rx_config {
-	struct acx_header header;
-
-	u32 config_options;
-	u32 filter_options;
-} __attribute__ ((packed));
-
-enum {
-	QOS_AC_BE = 0,
-	QOS_AC_BK,
-	QOS_AC_VI,
-	QOS_AC_VO,
-	QOS_HIGHEST_AC_INDEX = QOS_AC_VO,
-};
-
-#define MAX_NUM_OF_AC             (QOS_HIGHEST_AC_INDEX+1)
-#define FIRST_AC_INDEX            QOS_AC_BE
-#define MAX_NUM_OF_802_1d_TAGS    8
-#define AC_PARAMS_MAX_TSID        15
-#define MAX_APSD_CONF             0xffff
-
-#define  QOS_TX_HIGH_MIN      (0)
-#define  QOS_TX_HIGH_MAX      (100)
-
-#define  QOS_TX_HIGH_BK_DEF   (25)
-#define  QOS_TX_HIGH_BE_DEF   (35)
-#define  QOS_TX_HIGH_VI_DEF   (35)
-#define  QOS_TX_HIGH_VO_DEF   (35)
-
-#define  QOS_TX_LOW_BK_DEF    (15)
-#define  QOS_TX_LOW_BE_DEF    (25)
-#define  QOS_TX_LOW_VI_DEF    (25)
-#define  QOS_TX_LOW_VO_DEF    (25)
-
-struct acx_tx_queue_qos_config {
-	struct acx_header header;
-
-	u8 qid;
-	u8 pad[3];
-
-	/* Max number of blocks allowd in the queue */
-	u16 high_threshold;
-
-	/* Lowest memory blocks guaranteed for this queue */
-	u16 low_threshold;
-} __attribute__ ((packed));
-
-struct acx_packet_detection {
-	struct acx_header header;
-
-	u32 threshold;
-} __attribute__ ((packed));
-
-
-enum acx_slot_type {
-	SLOT_TIME_LONG = 0,
-	SLOT_TIME_SHORT = 1,
-	DEFAULT_SLOT_TIME = SLOT_TIME_SHORT,
-	MAX_SLOT_TIMES = 0xFF
-};
-
-#define STATION_WONE_INDEX 0
-
-struct acx_slot {
-	struct acx_header header;
-
-	u8 wone_index; /* Reserved */
-	u8 slot_time;
-	u8 reserved[6];
-} __attribute__ ((packed));
-
-
-#define ADDRESS_GROUP_MAX	(8)
-#define ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ADDRESS_GROUP_MAX)
-
-struct acx_dot11_grp_addr_tbl {
-	struct acx_header header;
-
-	u8 enabled;
-	u8 num_groups;
-	u8 pad[2];
-	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
-} __attribute__ ((packed));
-
-
-#define  RX_TIMEOUT_PS_POLL_MIN    0
-#define  RX_TIMEOUT_PS_POLL_MAX    (200000)
-#define  RX_TIMEOUT_PS_POLL_DEF    (15)
-#define  RX_TIMEOUT_UPSD_MIN       0
-#define  RX_TIMEOUT_UPSD_MAX       (200000)
-#define  RX_TIMEOUT_UPSD_DEF       (15)
-
-struct acx_rx_timeout {
-	struct acx_header header;
-
-	/*
-	 * The longest time the STA will wait to receive
-	 * traffic from the AP after a PS-poll has been
-	 * transmitted.
-	 */
-	u16 ps_poll_timeout;
-
-	/*
-	 * The longest time the STA will wait to receive
-	 * traffic from the AP after a frame has been sent
-	 * from an UPSD enabled queue.
-	 */
-	u16 upsd_timeout;
-} __attribute__ ((packed));
-
-#define RTS_THRESHOLD_MIN              0
-#define RTS_THRESHOLD_MAX              4096
-#define RTS_THRESHOLD_DEF              2347
-
-struct acx_rts_threshold {
-	struct acx_header header;
-
-	u16 threshold;
-	u8 pad[2];
-} __attribute__ ((packed));
-
-struct acx_beacon_filter_option {
-	struct acx_header header;
-
-	u8 enable;
-
-	/*
-	 * The number of beacons without the unicast TIM
-	 * bit set that the firmware buffers before
-	 * signaling the host about ready frames.
-	 * When set to 0 and the filter is enabled, beacons
-	 * without the unicast TIM bit set are dropped.
-	 */
-	u8 max_num_beacons;
-	u8 pad[2];
-} __attribute__ ((packed));
-
-/*
- * ACXBeaconFilterEntry (not 221)
- * Byte Offset     Size (Bytes)    Definition
- * ===========     ============    ==========
- * 0				1               IE identifier
- * 1               1               Treatment bit mask
- *
- * ACXBeaconFilterEntry (221)
- * Byte Offset     Size (Bytes)    Definition
- * ===========     ============    ==========
- * 0               1               IE identifier
- * 1               1               Treatment bit mask
- * 2               3               OUI
- * 5               1               Type
- * 6               2               Version
- *
- *
- * Treatment bit mask - The information element handling:
- * bit 0 - The information element is compared and transferred
- * in case of change.
- * bit 1 - The information element is transferred to the host
- * with each appearance or disappearance.
- * Note that both bits can be set at the same time.
- */
-#define	BEACON_FILTER_TABLE_MAX_IE_NUM		       (32)
-#define BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM (6)
-#define BEACON_FILTER_TABLE_IE_ENTRY_SIZE	       (2)
-#define BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE (6)
-#define BEACON_FILTER_TABLE_MAX_SIZE ((BEACON_FILTER_TABLE_MAX_IE_NUM * \
-			    BEACON_FILTER_TABLE_IE_ENTRY_SIZE) + \
-			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
-			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
-
-struct acx_beacon_filter_ie_table {
-	struct acx_header header;
-
-	u8 num_ie;
-	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
-	u8 pad[3];
-} __attribute__ ((packed));
-
-enum {
-	SG_ENABLE = 0,
-	SG_DISABLE,
-	SG_SENSE_NO_ACTIVITY,
-	SG_SENSE_ACTIVE
-};
-
-struct acx_bt_wlan_coex {
-	struct acx_header header;
-
-	/*
-	 * 0 -> PTA enabled
-	 * 1 -> PTA disabled
-	 * 2 -> sense no active mode, i.e.
-	 *      an interrupt is sent upon
-	 *      BT activity.
-	 * 3 -> PTA is switched on in response
-	 *      to the interrupt sending.
-	 */
-	u8 enable;
-	u8 pad[3];
-} __attribute__ ((packed));
-
-#define PTA_ANTENNA_TYPE_DEF		  (0)
-#define PTA_BT_HP_MAXTIME_DEF		  (2000)
-#define PTA_WLAN_HP_MAX_TIME_DEF	  (5000)
-#define PTA_SENSE_DISABLE_TIMER_DEF	  (1350)
-#define PTA_PROTECTIVE_RX_TIME_DEF	  (1500)
-#define PTA_PROTECTIVE_TX_TIME_DEF	  (1500)
-#define PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF (3000)
-#define PTA_SIGNALING_TYPE_DEF		  (1)
-#define PTA_AFH_LEVERAGE_ON_DEF		  (0)
-#define PTA_NUMBER_QUIET_CYCLE_DEF	  (0)
-#define PTA_MAX_NUM_CTS_DEF		  (3)
-#define PTA_NUMBER_OF_WLAN_PACKETS_DEF	  (2)
-#define PTA_NUMBER_OF_BT_PACKETS_DEF	  (2)
-#define PTA_PROTECTIVE_RX_TIME_FAST_DEF	  (1500)
-#define PTA_PROTECTIVE_TX_TIME_FAST_DEF	  (3000)
-#define PTA_CYCLE_TIME_FAST_DEF		  (8700)
-#define PTA_RX_FOR_AVALANCHE_DEF	  (5)
-#define PTA_ELP_HP_DEF			  (0)
-#define PTA_ANTI_STARVE_PERIOD_DEF	  (500)
-#define PTA_ANTI_STARVE_NUM_CYCLE_DEF	  (4)
-#define PTA_ALLOW_PA_SD_DEF		  (1)
-#define PTA_TIME_BEFORE_BEACON_DEF	  (6300)
-#define PTA_HPDM_MAX_TIME_DEF		  (1600)
-#define PTA_TIME_OUT_NEXT_WLAN_DEF	  (2550)
-#define PTA_AUTO_MODE_NO_CTS_DEF	  (0)
-#define PTA_BT_HP_RESPECTED_DEF		  (3)
-#define PTA_WLAN_RX_MIN_RATE_DEF	  (24)
-#define PTA_ACK_MODE_DEF		  (1)
-
-struct acx_bt_wlan_coex_param {
-	struct acx_header header;
-
-	/*
-	 * The minimum rate of a received WLAN packet in the STA,
-	 * during protective mode, of which a new BT-HP request
-	 * during this Rx will always be respected and gain the antenna.
-	 */
-	u32 min_rate;
-
-	/* Max time the BT HP will be respected. */
-	u16 bt_hp_max_time;
-
-	/* Max time the WLAN HP will be respected. */
-	u16 wlan_hp_max_time;
-
-	/*
-	 * The time between the last BT activity
-	 * and the moment when the sense mode returns
-	 * to SENSE_INACTIVE.
-	 */
-	u16 sense_disable_timer;
-
-	/* Time before the next BT HP instance */
-	u16 rx_time_bt_hp;
-	u16 tx_time_bt_hp;
-
-	/* range: 10-20000    default: 1500 */
-	u16 rx_time_bt_hp_fast;
-	u16 tx_time_bt_hp_fast;
-
-	/* range: 2000-65535  default: 8700 */
-	u16 wlan_cycle_fast;
-
-	/* range: 0 - 15000 (Msec) default: 1000 */
-	u16 bt_anti_starvation_period;
-
-	/* range 400-10000(Usec) default: 3000 */
-	u16 next_bt_lp_packet;
-
-	/* Deafult: worst case for BT DH5 traffic */
-	u16 wake_up_beacon;
-
-	/* range: 0-50000(Usec) default: 1050 */
-	u16 hp_dm_max_guard_time;
-
-	/*
-	 * This is to prevent both BT & WLAN antenna
-	 * starvation.
-	 * Range: 100-50000(Usec) default:2550
-	 */
-	u16 next_wlan_packet;
-
-	/* 0 -> shared antenna */
-	u8 antenna_type;
-
-	/*
-	 * 0 -> TI legacy
-	 * 1 -> Palau
-	 */
-	u8 signal_type;
-
-	/*
-	 * BT AFH status
-	 * 0 -> no AFH
-	 * 1 -> from dedicated GPIO
-	 * 2 -> AFH on (from host)
-	 */
-	u8 afh_leverage_on;
-
-	/*
-	 * The number of cycles during which no
-	 * TX will be sent after 1 cycle of RX
-	 * transaction in protective mode
-	 */
-	u8 quiet_cycle_num;
-
-	/*
-	 * The maximum number of CTSs that will
-	 * be sent for receiving RX packet in
-	 * protective mode
-	 */
-	u8 max_cts;
-
-	/*
-	 * The number of WLAN packets
-	 * transferred in common mode before
-	 * switching to BT.
-	 */
-	u8 wlan_packets_num;
-
-	/*
-	 * The number of BT packets
-	 * transferred in common mode before
-	 * switching to WLAN.
-	 */
-	u8 bt_packets_num;
-
-	/* range: 1-255  default: 5 */
-	u8 missed_rx_avalanche;
-
-	/* range: 0-1    default: 1 */
-	u8 wlan_elp_hp;
-
-	/* range: 0 - 15  default: 4 */
-	u8 bt_anti_starvation_cycles;
-
-	u8 ack_mode_dual_ant;
-
-	/*
-	 * Allow PA_SD assertion/de-assertion
-	 * during enabled BT activity.
-	 */
-	u8 pa_sd_enable;
-
-	/*
-	 * Enable/Disable PTA in auto mode:
-	 * Support Both Active & P.S modes
-	 */
-	u8 pta_auto_mode_enable;
-
-	/* range: 0 - 20  default: 1 */
-	u8 bt_hp_respected_num;
-} __attribute__ ((packed));
-
-#define CCA_THRSH_ENABLE_ENERGY_D       0x140A
-#define CCA_THRSH_DISABLE_ENERGY_D      0xFFEF
-
-struct acx_energy_detection {
-	struct acx_header header;
-
-	/* The RX Clear Channel Assessment threshold in the PHY */
-	u16 rx_cca_threshold;
-	u8 tx_energy_detection;
-	u8 pad;
-} __attribute__ ((packed));
-
-#define BCN_RX_TIMEOUT_DEF_VALUE        10000
-#define BROADCAST_RX_TIMEOUT_DEF_VALUE  20000
-#define RX_BROADCAST_IN_PS_DEF_VALUE    1
-#define CONSECUTIVE_PS_POLL_FAILURE_DEF 4
-
-struct acx_beacon_broadcast {
-	struct acx_header header;
-
-	u16 beacon_rx_timeout;
-	u16 broadcast_timeout;
-
-	/* Enables receiving of broadcast packets in PS mode */
-	u8 rx_broadcast_in_ps;
-
-	/* Consecutive PS Poll failures before updating the host */
-	u8 ps_poll_threshold;
-	u8 pad[2];
-} __attribute__ ((packed));
-
-struct acx_event_mask {
-	struct acx_header header;
-
-	u32 event_mask;
-	u32 high_event_mask; /* Unused */
-} __attribute__ ((packed));
-
-#define CFG_RX_FCS		BIT(2)
-#define CFG_RX_ALL_GOOD		BIT(3)
-#define CFG_UNI_FILTER_EN	BIT(4)
-#define CFG_BSSID_FILTER_EN	BIT(5)
-#define CFG_MC_FILTER_EN	BIT(6)
-#define CFG_MC_ADDR0_EN		BIT(7)
-#define CFG_MC_ADDR1_EN		BIT(8)
-#define CFG_BC_REJECT_EN	BIT(9)
-#define CFG_SSID_FILTER_EN	BIT(10)
-#define CFG_RX_INT_FCS_ERROR	BIT(11)
-#define CFG_RX_INT_ENCRYPTED	BIT(12)
-#define CFG_RX_WR_RX_STATUS	BIT(13)
-#define CFG_RX_FILTER_NULTI	BIT(14)
-#define CFG_RX_RESERVE		BIT(15)
-#define CFG_RX_TIMESTAMP_TSF	BIT(16)
-
-#define CFG_RX_RSV_EN		BIT(0)
-#define CFG_RX_RCTS_ACK		BIT(1)
-#define CFG_RX_PRSP_EN		BIT(2)
-#define CFG_RX_PREQ_EN		BIT(3)
-#define CFG_RX_MGMT_EN		BIT(4)
-#define CFG_RX_FCS_ERROR	BIT(5)
-#define CFG_RX_DATA_EN		BIT(6)
-#define CFG_RX_CTL_EN		BIT(7)
-#define CFG_RX_CF_EN		BIT(8)
-#define CFG_RX_BCN_EN		BIT(9)
-#define CFG_RX_AUTH_EN		BIT(10)
-#define CFG_RX_ASSOC_EN		BIT(11)
-
-#define SCAN_PASSIVE		BIT(0)
-#define SCAN_5GHZ_BAND		BIT(1)
-#define SCAN_TRIGGERED		BIT(2)
-#define SCAN_PRIORITY_HIGH	BIT(3)
-
-struct acx_fw_gen_frame_rates {
-	struct acx_header header;
-
-	u8 tx_ctrl_frame_rate; /* RATE_* */
-	u8 tx_ctrl_frame_mod; /* CCK_* or PBCC_* */
-	u8 tx_mgt_frame_rate;
-	u8 tx_mgt_frame_mod;
-} __attribute__ ((packed));
-
-/* STA MAC */
-struct acx_dot11_station_id {
-	struct acx_header header;
-
-	u8 mac[ETH_ALEN];
-	u8 pad[2];
-} __attribute__ ((packed));
-
-struct acx_feature_config {
-	struct acx_header header;
-
-	u32 options;
-	u32 data_flow_options;
-} __attribute__ ((packed));
-
-struct acx_current_tx_power {
-	struct acx_header header;
-
-	u8  current_tx_power;
-	u8  padding[3];
-} __attribute__ ((packed));
-
-struct acx_dot11_default_key {
-	struct acx_header header;
-
-	u8 id;
-	u8 pad[3];
-} __attribute__ ((packed));
-
-struct acx_tsf_info {
-	struct acx_header header;
-
-	u32 current_tsf_msb;
-	u32 current_tsf_lsb;
-	u32 last_TBTT_msb;
-	u32 last_TBTT_lsb;
-	u8 last_dtim_count;
-	u8 pad[3];
-} __attribute__ ((packed));
-
-enum acx_wake_up_event {
-	WAKE_UP_EVENT_BEACON_BITMAP	= 0x01, /* Wake on every Beacon*/
-	WAKE_UP_EVENT_DTIM_BITMAP	= 0x02,	/* Wake on every DTIM*/
-	WAKE_UP_EVENT_N_DTIM_BITMAP	= 0x04, /* Wake on every Nth DTIM */
-	WAKE_UP_EVENT_N_BEACONS_BITMAP	= 0x08, /* Wake on every Nth Beacon */
-	WAKE_UP_EVENT_BITS_MASK		= 0x0F
-};
-
-struct acx_wake_up_condition {
-	struct acx_header header;
-
-	u8 wake_up_event; /* Only one bit can be set */
-	u8 listen_interval;
-	u8 pad[2];
-} __attribute__ ((packed));
-
-struct acx_aid {
-	struct acx_header header;
-
-	/*
-	 * To be set when associated with an AP.
-	 */
-	u16 aid;
-	u8 pad[2];
-} __attribute__ ((packed));
-
-enum acx_preamble_type {
-	ACX_PREAMBLE_LONG = 0,
-	ACX_PREAMBLE_SHORT = 1
-};
-
-struct acx_preamble {
-	struct acx_header header;
-
-	/*
-	 * When set, the WiLink transmits the frames with a short preamble and
-	 * when cleared, the WiLink transmits the frames with a long preamble.
-	 */
-	u8 preamble;
-	u8 padding[3];
-} __attribute__ ((packed));
-
-enum acx_ctsprotect_type {
-	CTSPROTECT_DISABLE = 0,
-	CTSPROTECT_ENABLE = 1
-};
-
-struct acx_ctsprotect {
-	struct acx_header header;
-	u8 ctsprotect;
-	u8 padding[3];
-} __attribute__ ((packed));
-
-struct acx_tx_statistics {
-	u32 internal_desc_overflow;
-}  __attribute__ ((packed));
-
-struct acx_rx_statistics {
-	u32 out_of_mem;
-	u32 hdr_overflow;
-	u32 hw_stuck;
-	u32 dropped;
-	u32 fcs_err;
-	u32 xfr_hint_trig;
-	u32 path_reset;
-	u32 reset_counter;
-} __attribute__ ((packed));
-
-struct acx_dma_statistics {
-	u32 rx_requested;
-	u32 rx_errors;
-	u32 tx_requested;
-	u32 tx_errors;
-}  __attribute__ ((packed));
-
-struct acx_isr_statistics {
-	/* host command complete */
-	u32 cmd_cmplt;
-
-	/* fiqisr() */
-	u32 fiqs;
-
-	/* (INT_STS_ND & INT_TRIG_RX_HEADER) */
-	u32 rx_headers;
-
-	/* (INT_STS_ND & INT_TRIG_RX_CMPLT) */
-	u32 rx_completes;
-
-	/* (INT_STS_ND & INT_TRIG_NO_RX_BUF) */
-	u32 rx_mem_overflow;
-
-	/* (INT_STS_ND & INT_TRIG_S_RX_RDY) */
-	u32 rx_rdys;
-
-	/* irqisr() */
-	u32 irqs;
-
-	/* (INT_STS_ND & INT_TRIG_TX_PROC) */
-	u32 tx_procs;
-
-	/* (INT_STS_ND & INT_TRIG_DECRYPT_DONE) */
-	u32 decrypt_done;
-
-	/* (INT_STS_ND & INT_TRIG_DMA0) */
-	u32 dma0_done;
-
-	/* (INT_STS_ND & INT_TRIG_DMA1) */
-	u32 dma1_done;
-
-	/* (INT_STS_ND & INT_TRIG_TX_EXC_CMPLT) */
-	u32 tx_exch_complete;
-
-	/* (INT_STS_ND & INT_TRIG_COMMAND) */
-	u32 commands;
-
-	/* (INT_STS_ND & INT_TRIG_RX_PROC) */
-	u32 rx_procs;
-
-	/* (INT_STS_ND & INT_TRIG_PM_802) */
-	u32 hw_pm_mode_changes;
-
-	/* (INT_STS_ND & INT_TRIG_ACKNOWLEDGE) */
-	u32 host_acknowledges;
-
-	/* (INT_STS_ND & INT_TRIG_PM_PCI) */
-	u32 pci_pm;
-
-	/* (INT_STS_ND & INT_TRIG_ACM_WAKEUP) */
-	u32 wakeups;
-
-	/* (INT_STS_ND & INT_TRIG_LOW_RSSI) */
-	u32 low_rssi;
-} __attribute__ ((packed));
-
-struct acx_wep_statistics {
-	/* WEP address keys configured */
-	u32 addr_key_count;
-
-	/* default keys configured */
-	u32 default_key_count;
-
-	u32 reserved;
-
-	/* number of times that WEP key not found on lookup */
-	u32 key_not_found;
-
-	/* number of times that WEP key decryption failed */
-	u32 decrypt_fail;
-
-	/* WEP packets decrypted */
-	u32 packets;
-
-	/* WEP decrypt interrupts */
-	u32 interrupt;
-} __attribute__ ((packed));
-
-#define ACX_MISSED_BEACONS_SPREAD 10
-
-struct acx_pwr_statistics {
-	/* the amount of enters into power save mode (both PD & ELP) */
-	u32 ps_enter;
-
-	/* the amount of enters into ELP mode */
-	u32 elp_enter;
-
-	/* the amount of missing beacon interrupts to the host */
-	u32 missing_bcns;
-
-	/* the amount of wake on host-access times */
-	u32 wake_on_host;
-
-	/* the amount of wake on timer-expire */
-	u32 wake_on_timer_exp;
-
-	/* the number of packets that were transmitted with PS bit set */
-	u32 tx_with_ps;
-
-	/* the number of packets that were transmitted with PS bit clear */
-	u32 tx_without_ps;
-
-	/* the number of received beacons */
-	u32 rcvd_beacons;
-
-	/* the number of entering into PowerOn (power save off) */
-	u32 power_save_off;
-
-	/* the number of entries into power save mode */
-	u16 enable_ps;
-
-	/*
-	 * the number of exits from power save, not including failed PS
-	 * transitions
-	 */
-	u16 disable_ps;
-
-	/*
-	 * the number of times the TSF counter was adjusted because
-	 * of drift
-	 */
-	u32 fix_tsf_ps;
-
-	/* Gives statistics about the spread continuous missed beacons.
-	 * The 16 LSB are dedicated for the PS mode.
-	 * The 16 MSB are dedicated for the PS mode.
-	 * cont_miss_bcns_spread[0] - single missed beacon.
-	 * cont_miss_bcns_spread[1] - two continuous missed beacons.
-	 * cont_miss_bcns_spread[2] - three continuous missed beacons.
-	 * ...
-	 * cont_miss_bcns_spread[9] - ten and more continuous missed beacons.
-	*/
-	u32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
-
-	/* the number of beacons in awake mode */
-	u32 rcvd_awake_beacons;
-} __attribute__ ((packed));
-
-struct acx_mic_statistics {
-	u32 rx_pkts;
-	u32 calc_failure;
-} __attribute__ ((packed));
-
-struct acx_aes_statistics {
-	u32 encrypt_fail;
-	u32 decrypt_fail;
-	u32 encrypt_packets;
-	u32 decrypt_packets;
-	u32 encrypt_interrupt;
-	u32 decrypt_interrupt;
-} __attribute__ ((packed));
-
-struct acx_event_statistics {
-	u32 heart_beat;
-	u32 calibration;
-	u32 rx_mismatch;
-	u32 rx_mem_empty;
-	u32 rx_pool;
-	u32 oom_late;
-	u32 phy_transmit_error;
-	u32 tx_stuck;
-} __attribute__ ((packed));
-
-struct acx_ps_statistics {
-	u32 pspoll_timeouts;
-	u32 upsd_timeouts;
-	u32 upsd_max_sptime;
-	u32 upsd_max_apturn;
-	u32 pspoll_max_apturn;
-	u32 pspoll_utilization;
-	u32 upsd_utilization;
-} __attribute__ ((packed));
-
-struct acx_rxpipe_statistics {
-	u32 rx_prep_beacon_drop;
-	u32 descr_host_int_trig_rx_data;
-	u32 beacon_buffer_thres_host_int_trig_rx_data;
-	u32 missed_beacon_host_int_trig_rx_data;
-	u32 tx_xfr_host_int_trig_rx_data;
-} __attribute__ ((packed));
-
-struct acx_statistics {
-	struct acx_header header;
-
-	struct acx_tx_statistics tx;
-	struct acx_rx_statistics rx;
-	struct acx_dma_statistics dma;
-	struct acx_isr_statistics isr;
-	struct acx_wep_statistics wep;
-	struct acx_pwr_statistics pwr;
-	struct acx_aes_statistics aes;
-	struct acx_mic_statistics mic;
-	struct acx_event_statistics event;
-	struct acx_ps_statistics ps;
-	struct acx_rxpipe_statistics rxpipe;
-} __attribute__ ((packed));
-
-enum {
-	ACX_WAKE_UP_CONDITIONS      = 0x0002,
-	ACX_MEM_CFG                 = 0x0003,
-	ACX_SLOT                    = 0x0004,
-	ACX_QUEUE_HEAD              = 0x0005, /* for MASTER mode only */
-	ACX_AC_CFG                  = 0x0007,
-	ACX_MEM_MAP                 = 0x0008,
-	ACX_AID                     = 0x000A,
-	ACX_RADIO_PARAM             = 0x000B, /* Not used */
-	ACX_CFG                     = 0x000C, /* Not used */
-	ACX_FW_REV                  = 0x000D,
-	ACX_MEDIUM_USAGE            = 0x000F,
-	ACX_RX_CFG                  = 0x0010,
-	ACX_TX_QUEUE_CFG            = 0x0011, /* FIXME: only used by wl1251 */
-	ACX_BSS_IN_PS               = 0x0012, /* for AP only */
-	ACX_STATISTICS              = 0x0013, /* Debug API */
-	ACX_FEATURE_CFG             = 0x0015,
-	ACX_MISC_CFG                = 0x0017, /* Not used */
-	ACX_TID_CFG                 = 0x001A,
-	ACX_BEACON_FILTER_OPT       = 0x001F,
-	ACX_LOW_RSSI                = 0x0020,
-	ACX_NOISE_HIST              = 0x0021,
-	ACX_HDK_VERSION             = 0x0022, /* ??? */
-	ACX_PD_THRESHOLD            = 0x0023,
-	ACX_DATA_PATH_PARAMS        = 0x0024, /* WO */
-	ACX_DATA_PATH_RESP_PARAMS   = 0x0024, /* RO */
-	ACX_CCA_THRESHOLD           = 0x0025,
-	ACX_EVENT_MBOX_MASK         = 0x0026,
-#ifdef FW_RUNNING_AS_AP
-	ACX_DTIM_PERIOD             = 0x0027, /* for AP only */
-#else
-	ACX_WR_TBTT_AND_DTIM        = 0x0027, /* STA only */
-#endif
-	ACX_ACI_OPTION_CFG          = 0x0029, /* OBSOLETE (for 1251)*/
-	ACX_GPIO_CFG                = 0x002A, /* Not used */
-	ACX_GPIO_SET                = 0x002B, /* Not used */
-	ACX_PM_CFG                  = 0x002C, /* To Be Documented */
-	ACX_CONN_MONIT_PARAMS       = 0x002D,
-	ACX_AVERAGE_RSSI            = 0x002E, /* Not used */
-	ACX_CONS_TX_FAILURE         = 0x002F,
-	ACX_BCN_DTIM_OPTIONS        = 0x0031,
-	ACX_SG_ENABLE               = 0x0032,
-	ACX_SG_CFG                  = 0x0033,
-	ACX_ANTENNA_DIVERSITY_CFG   = 0x0035, /* To Be Documented */
-	ACX_LOW_SNR		    = 0x0037, /* To Be Documented */
-	ACX_BEACON_FILTER_TABLE     = 0x0038,
-	ACX_ARP_IP_FILTER           = 0x0039,
-	ACX_ROAMING_STATISTICS_TBL  = 0x003B,
-	ACX_RATE_POLICY             = 0x003D,
-	ACX_CTS_PROTECTION          = 0x003E,
-	ACX_SLEEP_AUTH              = 0x003F,
-	ACX_PREAMBLE_TYPE	    = 0x0040,
-	ACX_ERROR_CNT               = 0x0041,
-	ACX_FW_GEN_FRAME_RATES      = 0x0042,
-	ACX_IBSS_FILTER		    = 0x0044,
-	ACX_SERVICE_PERIOD_TIMEOUT  = 0x0045,
-	ACX_TSF_INFO                = 0x0046,
-	ACX_CONFIG_PS_WMM           = 0x0049,
-	ACX_ENABLE_RX_DATA_FILTER   = 0x004A,
-	ACX_SET_RX_DATA_FILTER      = 0x004B,
-	ACX_GET_DATA_FILTER_STATISTICS = 0x004C,
-	ACX_POWER_LEVEL_TABLE       = 0x004D,
-	ACX_BET_ENABLE              = 0x0050,
-	DOT11_STATION_ID            = 0x1001,
-	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
-	DOT11_CUR_TX_PWR            = 0x100D,
-	DOT11_DEFAULT_KEY           = 0x1010,
-	DOT11_RX_DOT11_MODE         = 0x1012,
-	DOT11_RTS_THRESHOLD         = 0x1013,
-	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
-
-	MAX_DOT11_IE = DOT11_GROUP_ADDRESS_TBL,
-
-	MAX_IE = 0xFFFF
-};
-
-
-int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
-			   u8 mgt_rate, u8 mgt_mod);
-int wl12xx_acx_station_id(struct wl12xx *wl);
-int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id);
-int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
-				  u8 listen_interval);
-int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth);
-int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len);
-int wl12xx_acx_tx_power(struct wl12xx *wl, int power);
-int wl12xx_acx_feature_cfg(struct wl12xx *wl);
-int wl12xx_acx_mem_map(struct wl12xx *wl,
-		       struct acx_header *mem_map, size_t len);
-int wl12xx_acx_data_path_params(struct wl12xx *wl,
-				struct acx_data_path_params_resp *data_path);
-int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time);
-int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter);
-int wl12xx_acx_pd_threshold(struct wl12xx *wl);
-int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time);
-int wl12xx_acx_group_address_tbl(struct wl12xx *wl);
-int wl12xx_acx_service_period_timeout(struct wl12xx *wl);
-int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold);
-int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl);
-int wl12xx_acx_beacon_filter_table(struct wl12xx *wl);
-int wl12xx_acx_sg_enable(struct wl12xx *wl);
-int wl12xx_acx_sg_cfg(struct wl12xx *wl);
-int wl12xx_acx_cca_threshold(struct wl12xx *wl);
-int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl);
-int wl12xx_acx_aid(struct wl12xx *wl, u16 aid);
-int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask);
-int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble);
-int wl12xx_acx_cts_protect(struct wl12xx *wl,
-			    enum acx_ctsprotect_type ctsprotect);
-int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats);
-int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime);
-
-#endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
deleted file mode 100644
index a6a2649..0000000
--- a/drivers/net/wireless/wl12xx/boot.c
+++ /dev/null
@@ -1,297 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/gpio.h>
-
-#include "reg.h"
-#include "boot.h"
-#include "spi.h"
-#include "event.h"
-
-static void wl12xx_boot_enable_interrupts(struct wl12xx *wl)
-{
-	enable_irq(wl->irq);
-}
-
-void wl12xx_boot_target_enable_interrupts(struct wl12xx *wl)
-{
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
-	wl12xx_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
-}
-
-int wl12xx_boot_soft_reset(struct wl12xx *wl)
-{
-	unsigned long timeout;
-	u32 boot_data;
-
-	/* perform soft reset */
-	wl12xx_reg_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
-
-	/* SOFT_RESET is self clearing */
-	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
-	while (1) {
-		boot_data = wl12xx_reg_read32(wl, ACX_REG_SLV_SOFT_RESET);
-		wl12xx_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
-		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
-			break;
-
-		if (time_after(jiffies, timeout)) {
-			/* 1.2 check pWhalBus->uSelfClearTime if the
-			 * timeout was reached */
-			wl12xx_error("soft reset timeout");
-			return -1;
-		}
-
-		udelay(SOFT_RESET_STALL_TIME);
-	}
-
-	/* disable Rx/Tx */
-	wl12xx_reg_write32(wl, ENABLE, 0x0);
-
-	/* disable auto calibration on start*/
-	wl12xx_reg_write32(wl, SPARE_A2, 0xffff);
-
-	return 0;
-}
-
-int wl12xx_boot_init_seq(struct wl12xx *wl)
-{
-	u32 scr_pad6, init_data, tmp, elp_cmd, ref_freq;
-
-	/*
-	 * col #1: INTEGER_DIVIDER
-	 * col #2: FRACTIONAL_DIVIDER
-	 * col #3: ATTN_BB
-	 * col #4: ALPHA_BB
-	 * col #5: STOP_TIME_BB
-	 * col #6: BB_PLL_LOOP_FILTER
-	 */
-	static const u32 LUT[REF_FREQ_NUM][LUT_PARAM_NUM] = {
-
-		{   83, 87381,  0xB, 5, 0xF00,  3}, /* REF_FREQ_19_2*/
-		{   61, 141154, 0xB, 5, 0x1450, 2}, /* REF_FREQ_26_0*/
-		{   41, 174763, 0xC, 6, 0x2D00, 1}, /* REF_FREQ_38_4*/
-		{   40, 0,      0xC, 6, 0x2EE0, 1}, /* REF_FREQ_40_0*/
-		{   47, 162280, 0xC, 6, 0x2760, 1}  /* REF_FREQ_33_6        */
-	};
-
-	/* read NVS params */
-	scr_pad6 = wl12xx_reg_read32(wl, SCR_PAD6);
-	wl12xx_debug(DEBUG_BOOT, "scr_pad6 0x%x", scr_pad6);
-
-	/* read ELP_CMD */
-	elp_cmd = wl12xx_reg_read32(wl, ELP_CMD);
-	wl12xx_debug(DEBUG_BOOT, "elp_cmd 0x%x", elp_cmd);
-
-	/* set the BB calibration time to be 300 usec (PLL_CAL_TIME) */
-	ref_freq = scr_pad6 & 0x000000FF;
-	wl12xx_debug(DEBUG_BOOT, "ref_freq 0x%x", ref_freq);
-
-	wl12xx_reg_write32(wl, PLL_CAL_TIME, 0x9);
-
-	/*
-	 * PG 1.2: set the clock buffer time to be 210 usec (CLK_BUF_TIME)
-	 */
-	wl12xx_reg_write32(wl, CLK_BUF_TIME, 0x6);
-
-	/*
-	 * set the clock detect feature to work in the restart wu procedure
-	 * (ELP_CFG_MODE[14]) and Select the clock source type
-	 * (ELP_CFG_MODE[13:12])
-	 */
-	tmp = ((scr_pad6 & 0x0000FF00) << 4) | 0x00004000;
-	wl12xx_reg_write32(wl, ELP_CFG_MODE, tmp);
-
-	/* PG 1.2: enable the BB PLL fix. Enable the PLL_LIMP_CLK_EN_CMD */
-	elp_cmd |= 0x00000040;
-	wl12xx_reg_write32(wl, ELP_CMD, elp_cmd);
-
-	/* PG 1.2: Set the BB PLL stable time to be 1000usec
-	 * (PLL_STABLE_TIME) */
-	wl12xx_reg_write32(wl, CFG_PLL_SYNC_CNT, 0x20);
-
-	/* PG 1.2: read clock request time */
-	init_data = wl12xx_reg_read32(wl, CLK_REQ_TIME);
-
-	/*
-	 * PG 1.2: set the clock request time to be ref_clk_settling_time -
-	 * 1ms = 4ms
-	 */
-	if (init_data > 0x21)
-		tmp = init_data - 0x21;
-	else
-		tmp = 0;
-	wl12xx_reg_write32(wl, CLK_REQ_TIME, tmp);
-
-	/* set BB PLL configurations in RF AFE */
-	wl12xx_reg_write32(wl, 0x003058cc, 0x4B5);
-
-	/* set RF_AFE_REG_5 */
-	wl12xx_reg_write32(wl, 0x003058d4, 0x50);
-
-	/* set RF_AFE_CTRL_REG_2 */
-	wl12xx_reg_write32(wl, 0x00305948, 0x11c001);
-
-	/*
-	 * change RF PLL and BB PLL divider for VCO clock and adjust VCO
-	 * bais current(RF_AFE_REG_13)
-	 */
-	wl12xx_reg_write32(wl, 0x003058f4, 0x1e);
-
-	/* set BB PLL configurations */
-	tmp = LUT[ref_freq][LUT_PARAM_INTEGER_DIVIDER] | 0x00017000;
-	wl12xx_reg_write32(wl, 0x00305840, tmp);
-
-	/* set fractional divider according to Appendix C-BB PLL
-	 * Calculations
-	 */
-	tmp = LUT[ref_freq][LUT_PARAM_FRACTIONAL_DIVIDER];
-	wl12xx_reg_write32(wl, 0x00305844, tmp);
-
-	/* set the initial data for the sigma delta */
-	wl12xx_reg_write32(wl, 0x00305848, 0x3039);
-
-	/*
-	 * set the accumulator attenuation value, calibration loop1
-	 * (alpha), calibration loop2 (beta), calibration loop3 (gamma) and
-	 * the VCO gain
-	 */
-	tmp = (LUT[ref_freq][LUT_PARAM_ATTN_BB] << 16) |
-		(LUT[ref_freq][LUT_PARAM_ALPHA_BB] << 12) | 0x1;
-	wl12xx_reg_write32(wl, 0x00305854, tmp);
-
-	/*
-	 * set the calibration stop time after holdoff time expires and set
-	 * settling time HOLD_OFF_TIME_BB
-	 */
-	tmp = LUT[ref_freq][LUT_PARAM_STOP_TIME_BB] | 0x000A0000;
-	wl12xx_reg_write32(wl, 0x00305858, tmp);
-
-	/*
-	 * set BB PLL Loop filter capacitor3- BB_C3[2:0] and set BB PLL
-	 * constant leakage current to linearize PFD to 0uA -
-	 * BB_ILOOPF[7:3]
-	 */
-	tmp = LUT[ref_freq][LUT_PARAM_BB_PLL_LOOP_FILTER] | 0x00000030;
-	wl12xx_reg_write32(wl, 0x003058f8, tmp);
-
-	/*
-	 * set regulator output voltage for n divider to
-	 * 1.35-BB_REFDIV[1:0], set charge pump current- BB_CPGAIN[4:2],
-	 * set BB PLL Loop filter capacitor2- BB_C2[7:5], set gain of BB
-	 * PLL auto-call to normal mode- BB_CALGAIN_3DB[8]
-	 */
-	wl12xx_reg_write32(wl, 0x003058f0, 0x29);
-
-	/* enable restart wakeup sequence (ELP_CMD[0]) */
-	wl12xx_reg_write32(wl, ELP_CMD, elp_cmd | 0x1);
-
-	/* restart sequence completed */
-	udelay(2000);
-
-	return 0;
-}
-
-int wl12xx_boot_run_firmware(struct wl12xx *wl)
-{
-	int loop, ret;
-	u32 chip_id, interrupt;
-
-	wl->chip.op_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
-
-	chip_id = wl12xx_reg_read32(wl, CHIP_ID_B);
-
-	wl12xx_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
-
-	if (chip_id != wl->chip.id) {
-		wl12xx_error("chip id doesn't match after firmware boot");
-		return -EIO;
-	}
-
-	/* wait for init to complete */
-	loop = 0;
-	while (loop++ < INIT_LOOP) {
-		udelay(INIT_LOOP_DELAY);
-		interrupt = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
-
-		if (interrupt == 0xffffffff) {
-			wl12xx_error("error reading hardware complete "
-				     "init indication");
-			return -EIO;
-		}
-		/* check that ACX_INTR_INIT_COMPLETE is enabled */
-		else if (interrupt & wl->chip.intr_init_complete) {
-			wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
-					   wl->chip.intr_init_complete);
-			break;
-		}
-	}
-
-	if (loop >= INIT_LOOP) {
-		wl12xx_error("timeout waiting for the hardware to "
-			     "complete initialization");
-		return -EIO;
-	}
-
-	/* get hardware config command mail box */
-	wl->cmd_box_addr = wl12xx_reg_read32(wl, REG_COMMAND_MAILBOX_PTR);
-
-	/* get hardware config event mail box */
-	wl->event_box_addr = wl12xx_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
-
-	/* set the working partition to its "running" mode offset */
-	wl12xx_set_partition(wl,
-			     wl->chip.p_table[PART_WORK].mem.start,
-			     wl->chip.p_table[PART_WORK].mem.size,
-			     wl->chip.p_table[PART_WORK].reg.start,
-			     wl->chip.p_table[PART_WORK].reg.size);
-
-	wl12xx_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
-		     wl->cmd_box_addr, wl->event_box_addr);
-
-	wl->chip.op_fw_version(wl);
-
-	/*
-	 * in case of full asynchronous mode the firmware event must be
-	 * ready to receive event from the command mailbox
-	 */
-
-	/* enable gpio interrupts */
-	wl12xx_boot_enable_interrupts(wl);
-
-	wl->chip.op_target_enable_interrupts(wl);
-
-	/* unmask all mbox events  */
-	wl->event_mask = 0xffffffff;
-
-	ret = wl12xx_event_unmask(wl);
-	if (ret < 0) {
-		wl12xx_error("EVENT mask setting failed");
-		return ret;
-	}
-
-	wl12xx_event_mbox_config(wl);
-
-	/* firmware startup completed */
-	return 0;
-}
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
deleted file mode 100644
index 4fa7313..0000000
--- a/drivers/net/wireless/wl12xx/boot.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __BOOT_H__
-#define __BOOT_H__
-
-#include "wl12xx.h"
-
-int wl12xx_boot_soft_reset(struct wl12xx *wl);
-int wl12xx_boot_init_seq(struct wl12xx *wl);
-int wl12xx_boot_run_firmware(struct wl12xx *wl);
-void wl12xx_boot_target_enable_interrupts(struct wl12xx *wl);
-
-/* number of times we try to read the INIT interrupt */
-#define INIT_LOOP 20000
-
-/* delay between retries */
-#define INIT_LOOP_DELAY 50
-
-#endif
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
deleted file mode 100644
index cad258d..0000000
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ /dev/null
@@ -1,429 +0,0 @@
-#include "cmd.h"
-
-#include <linux/module.h>
-#include <linux/crc7.h>
-#include <linux/spi/spi.h>
-
-#include "wl12xx.h"
-#include "wl12xx_80211.h"
-#include "reg.h"
-#include "spi.h"
-#include "ps.h"
-#include "acx.h"
-
-/**
- * send command to firmware
- *
- * @wl: wl struct
- * @id: command id
- * @buf: buffer containing the command, must work with dma
- * @len: length of the buffer
- */
-int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
-{
-	struct wl12xx_cmd_header *cmd;
-	unsigned long timeout;
-	u32 intr;
-	int ret = 0;
-
-	cmd = buf;
-	cmd->id = id;
-	cmd->status = 0;
-
-	WARN_ON(len % 4 != 0);
-
-	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
-
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
-
-	timeout = jiffies + msecs_to_jiffies(WL12XX_COMMAND_TIMEOUT);
-
-	intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
-	while (!(intr & wl->chip.intr_cmd_complete)) {
-		if (time_after(jiffies, timeout)) {
-			wl12xx_error("command complete timeout");
-			ret = -ETIMEDOUT;
-			goto out;
-		}
-
-		msleep(1);
-
-		intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
-	}
-
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
-			   wl->chip.intr_cmd_complete);
-
-out:
-	return ret;
-}
-
-/**
- * send test command to firmware
- *
- * @wl: wl struct
- * @buf: buffer containing the command, with all headers, must work with dma
- * @len: length of the buffer
- * @answer: is answer needed
- */
-int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
-{
-	int ret;
-
-	wl12xx_debug(DEBUG_CMD, "cmd test");
-
-	ret = wl12xx_cmd_send(wl, CMD_TEST, buf, buf_len);
-
-	if (ret < 0) {
-		wl12xx_warning("TEST command failed");
-		return ret;
-	}
-
-	if (answer) {
-		struct wl12xx_command *cmd_answer;
-
-		/*
-		 * The test command got in, we can read the answer.
-		 * The answer would be a wl12xx_command, where the
-		 * parameter array contains the actual answer.
-		 */
-		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
-
-		cmd_answer = buf;
-
-		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
-			wl12xx_error("TEST command answer error: %d",
-				     cmd_answer->header.status);
-	}
-
-	return 0;
-}
-
-/**
- * read acx from firmware
- *
- * @wl: wl struct
- * @id: acx id
- * @buf: buffer for the response, including all headers, must work with dma
- * @len: lenght of buf
- */
-int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len)
-{
-	struct acx_header *acx = buf;
-	int ret;
-
-	wl12xx_debug(DEBUG_CMD, "cmd interrogate");
-
-	acx->id = id;
-
-	/* payload length, does not include any headers */
-	acx->len = len - sizeof(*acx);
-
-	ret = wl12xx_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl12xx_error("INTERROGATE command failed");
-		goto out;
-	}
-
-	/* the interrogate command got in, we can read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
-
-	acx = buf;
-	if (acx->cmd.status != CMD_STATUS_SUCCESS)
-		wl12xx_error("INTERROGATE command error: %d",
-			     acx->cmd.status);
-
-out:
-	return ret;
-}
-
-/**
- * write acx value to firmware
- *
- * @wl: wl struct
- * @id: acx id
- * @buf: buffer containing acx, including all headers, must work with dma
- * @len: length of buf
- */
-int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len)
-{
-	struct acx_header *acx = buf;
-	int ret;
-
-	wl12xx_debug(DEBUG_CMD, "cmd configure");
-
-	acx->id = id;
-
-	/* payload length, does not include any headers */
-	acx->len = len - sizeof(*acx);
-
-	ret = wl12xx_cmd_send(wl, CMD_CONFIGURE, acx, len);
-	if (ret < 0) {
-		wl12xx_warning("CONFIGURE command NOK");
-		return ret;
-	}
-
-	return 0;
-}
-
-int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
-		   void *bitmap, u16 bitmap_len, u8 bitmap_control)
-{
-	struct wl12xx_cmd_vbm_update *vbm;
-	int ret;
-
-	wl12xx_debug(DEBUG_CMD, "cmd vbm");
-
-	vbm = kzalloc(sizeof(*vbm), GFP_KERNEL);
-	if (!vbm) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* Count and period will be filled by the target */
-	vbm->tim.bitmap_ctrl = bitmap_control;
-	if (bitmap_len > PARTIAL_VBM_MAX) {
-		wl12xx_warning("cmd vbm len is %d B, truncating to %d",
-			       bitmap_len, PARTIAL_VBM_MAX);
-		bitmap_len = PARTIAL_VBM_MAX;
-	}
-	memcpy(vbm->tim.pvb_field, bitmap, bitmap_len);
-	vbm->tim.identity = identity;
-	vbm->tim.length = bitmap_len + 3;
-
-	vbm->len = cpu_to_le16(bitmap_len + 5);
-
-	ret = wl12xx_cmd_send(wl, CMD_VBM, vbm, sizeof(*vbm));
-	if (ret < 0) {
-		wl12xx_error("VBM command failed");
-		goto out;
-	}
-
-out:
-	kfree(vbm);
-	return 0;
-}
-
-int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable)
-{
-	struct cmd_enabledisable_path *cmd;
-	int ret;
-	u16 cmd_rx, cmd_tx;
-
-	wl12xx_debug(DEBUG_CMD, "cmd data path");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	cmd->channel = channel;
-
-	if (enable) {
-		cmd_rx = CMD_ENABLE_RX;
-		cmd_tx = CMD_ENABLE_TX;
-	} else {
-		cmd_rx = CMD_DISABLE_RX;
-		cmd_tx = CMD_DISABLE_TX;
-	}
-
-	ret = wl12xx_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
-	if (ret < 0) {
-		wl12xx_error("rx %s cmd for channel %d failed",
-			     enable ? "start" : "stop", channel);
-		goto out;
-	}
-
-	wl12xx_debug(DEBUG_BOOT, "rx %s cmd channel %d",
-		     enable ? "start" : "stop", channel);
-
-	ret = wl12xx_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
-	if (ret < 0) {
-		wl12xx_error("tx %s cmd for channel %d failed",
-			     enable ? "start" : "stop", channel);
-		return ret;
-	}
-
-	wl12xx_debug(DEBUG_BOOT, "tx %s cmd channel %d",
-		     enable ? "start" : "stop", channel);
-
-out:
-	kfree(cmd);
-	return ret;
-}
-
-int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
-		    u16 beacon_interval, u8 wait)
-{
-	unsigned long timeout;
-	struct cmd_join *join;
-	int ret, i;
-	u8 *bssid;
-
-	join = kzalloc(sizeof(*join), GFP_KERNEL);
-	if (!join) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* FIXME: this should be in main.c */
-	ret = wl12xx_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
-				     DEFAULT_HW_GEN_MODULATION_TYPE,
-				     wl->tx_mgmt_frm_rate,
-				     wl->tx_mgmt_frm_mod);
-	if (ret < 0)
-		goto out;
-
-	wl12xx_debug(DEBUG_CMD, "cmd join");
-
-	/* Reverse order BSSID */
-	bssid = (u8 *) &join->bssid_lsb;
-	for (i = 0; i < ETH_ALEN; i++)
-		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
-
-	join->rx_config_options = wl->rx_config;
-	join->rx_filter_options = wl->rx_filter;
-
-	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
-		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
-
-	join->beacon_interval = beacon_interval;
-	join->dtim_interval = dtim_interval;
-	join->bss_type = bss_type;
-	join->channel = wl->channel;
-	join->ctrl = JOIN_CMD_CTRL_TX_FLUSH;
-
-	ret = wl12xx_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
-	if (ret < 0) {
-		wl12xx_error("failed to initiate cmd join");
-		goto out;
-	}
-
-	timeout = msecs_to_jiffies(JOIN_TIMEOUT);
-
-	/*
-	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
-	 * simplify locking we just sleep instead, for now
-	 */
-	if (wait)
-		msleep(10);
-
-out:
-	kfree(join);
-	return ret;
-}
-
-int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode)
-{
-	struct wl12xx_cmd_ps_params *ps_params = NULL;
-	int ret = 0;
-
-	/* FIXME: this should be in ps.c */
-	ret = wl12xx_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
-					    wl->listen_int);
-	if (ret < 0) {
-		wl12xx_error("couldn't set wake up conditions");
-		goto out;
-	}
-
-	wl12xx_debug(DEBUG_CMD, "cmd set ps mode");
-
-	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
-	if (!ps_params) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ps_params->ps_mode = ps_mode;
-	ps_params->send_null_data = 1;
-	ps_params->retries = 5;
-	ps_params->hang_over_period = 128;
-	ps_params->null_data_rate = 1; /* 1 Mbps */
-
-	ret = wl12xx_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
-			      sizeof(*ps_params));
-	if (ret < 0) {
-		wl12xx_error("cmd set_ps_mode failed");
-		goto out;
-	}
-
-out:
-	kfree(ps_params);
-	return ret;
-}
-
-int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
-			   size_t len)
-{
-	struct cmd_read_write_memory *cmd;
-	int ret = 0;
-
-	wl12xx_debug(DEBUG_CMD, "cmd read memory");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	WARN_ON(len > MAX_READ_SIZE);
-	len = min_t(size_t, len, MAX_READ_SIZE);
-
-	cmd->addr = addr;
-	cmd->size = len;
-
-	ret = wl12xx_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
-	if (ret < 0) {
-		wl12xx_error("read memory command failed: %d", ret);
-		goto out;
-	}
-
-	/* the read command got in, we can now read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
-
-	if (cmd->header.status != CMD_STATUS_SUCCESS)
-		wl12xx_error("error in read command result: %d",
-			     cmd->header.status);
-
-	memcpy(answer, cmd->value, len);
-
-out:
-	kfree(cmd);
-	return ret;
-}
-
-int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
-			    void *buf, size_t buf_len)
-{
-	struct wl12xx_cmd_packet_template *cmd;
-	size_t cmd_len;
-	int ret = 0;
-
-	wl12xx_debug(DEBUG_CMD, "cmd template %d", cmd_id);
-
-	WARN_ON(buf_len > WL12XX_MAX_TEMPLATE_SIZE);
-	buf_len = min_t(size_t, buf_len, WL12XX_MAX_TEMPLATE_SIZE);
-	cmd_len = ALIGN(sizeof(*cmd) + buf_len, 4);
-
-	cmd = kzalloc(cmd_len, GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	cmd->size = cpu_to_le16(buf_len);
-
-	if (buf)
-		memcpy(cmd->data, buf, buf_len);
-
-	ret = wl12xx_cmd_send(wl, cmd_id, cmd, cmd_len);
-	if (ret < 0) {
-		wl12xx_warning("cmd set_template failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(cmd);
-	return ret;
-}
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
deleted file mode 100644
index a2eae54..0000000
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ /dev/null
@@ -1,407 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_CMD_H__
-#define __WL12XX_CMD_H__
-
-#include "wl12xx.h"
-
-struct acx_header;
-
-int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len);
-int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer);
-int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len);
-int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len);
-int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
-		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
-int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable);
-int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
-		    u16 beacon_interval, u8 wait);
-int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode);
-int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
-			   size_t len);
-int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
-			    void *buf, size_t buf_len);
-
-/* unit ms */
-#define WL12XX_COMMAND_TIMEOUT 2000
-
-enum wl12xx_commands {
-	CMD_RESET           = 0,
-	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
-	CMD_CONFIGURE       = 2,    /*use this to write information elements*/
-	CMD_ENABLE_RX       = 3,
-	CMD_ENABLE_TX       = 4,
-	CMD_DISABLE_RX      = 5,
-	CMD_DISABLE_TX      = 6,
-	CMD_SCAN            = 8,
-	CMD_STOP_SCAN       = 9,
-	CMD_VBM             = 10,
-	CMD_START_JOIN      = 11,
-	CMD_SET_KEYS        = 12,
-	CMD_READ_MEMORY     = 13,
-	CMD_WRITE_MEMORY    = 14,
-	CMD_BEACON          = 19,
-	CMD_PROBE_RESP      = 20,
-	CMD_NULL_DATA       = 21,
-	CMD_PROBE_REQ       = 22,
-	CMD_TEST            = 23,
-	CMD_RADIO_CALIBRATE     = 25,   /* OBSOLETE */
-	CMD_ENABLE_RX_PATH      = 27,   /* OBSOLETE */
-	CMD_NOISE_HIST      = 28,
-	CMD_RX_RESET        = 29,
-	CMD_PS_POLL         = 30,
-	CMD_QOS_NULL_DATA   = 31,
-	CMD_LNA_CONTROL     = 32,
-	CMD_SET_BCN_MODE    = 33,
-	CMD_MEASUREMENT      = 34,
-	CMD_STOP_MEASUREMENT = 35,
-	CMD_DISCONNECT       = 36,
-	CMD_SET_PS_MODE      = 37,
-	CMD_CHANNEL_SWITCH   = 38,
-	CMD_STOP_CHANNEL_SWICTH = 39,
-	CMD_AP_DISCOVERY     = 40,
-	CMD_STOP_AP_DISCOVERY = 41,
-	CMD_SPS_SCAN = 42,
-	CMD_STOP_SPS_SCAN = 43,
-	CMD_HEALTH_CHECK     = 45,
-	CMD_DEBUG            = 46,
-	CMD_TRIGGER_SCAN_TO  = 47,
-
-	NUM_COMMANDS,
-	MAX_COMMAND_ID = 0xFFFF,
-};
-
-#define MAX_CMD_PARAMS 572
-
-struct wl12xx_cmd_header {
-	u16 id;
-	u16 status;
-	/* payload */
-	u8 data[0];
-} __attribute__ ((packed));
-
-struct  wl12xx_command {
-	struct wl12xx_cmd_header header;
-	u8  parameters[MAX_CMD_PARAMS];
-};
-
-enum {
-	CMD_MAILBOX_IDLE              		=  0,
-	CMD_STATUS_SUCCESS            		=  1,
-	CMD_STATUS_UNKNOWN_CMD        		=  2,
-	CMD_STATUS_UNKNOWN_IE         		=  3,
-	CMD_STATUS_REJECT_MEAS_SG_ACTIVE 	= 11,
-	CMD_STATUS_RX_BUSY            		= 13,
-	CMD_STATUS_INVALID_PARAM      		= 14,
-	CMD_STATUS_TEMPLATE_TOO_LARGE 		= 15,
-	CMD_STATUS_OUT_OF_MEMORY      		= 16,
-	CMD_STATUS_STA_TABLE_FULL     		= 17,
-	CMD_STATUS_RADIO_ERROR        		= 18,
-	CMD_STATUS_WRONG_NESTING      		= 19,
-	CMD_STATUS_TIMEOUT            		= 21, /* Driver internal use.*/
-	CMD_STATUS_FW_RESET           		= 22, /* Driver internal use.*/
-	MAX_COMMAND_STATUS            		= 0xff
-};
-
-
-/*
- * CMD_READ_MEMORY
- *
- * The host issues this command to read the WiLink device memory/registers.
- *
- * Note: The Base Band address has special handling (16 bits registers and
- * addresses). For more information, see the hardware specification.
- */
-/*
- * CMD_WRITE_MEMORY
- *
- * The host issues this command to write the WiLink device memory/registers.
- *
- * The Base Band address has special handling (16 bits registers and
- * addresses). For more information, see the hardware specification.
- */
-#define MAX_READ_SIZE 256
-
-struct cmd_read_write_memory {
-	struct wl12xx_cmd_header header;
-
-	/* The address of the memory to read from or write to.*/
-	u32 addr;
-
-	/* The amount of data in bytes to read from or write to the WiLink
-	 * device.*/
-	u32 size;
-
-	/* The actual value read from or written to the Wilink. The source
-	   of this field is the Host in WRITE command or the Wilink in READ
-	   command. */
-	u8 value[MAX_READ_SIZE];
-};
-
-#define CMDMBOX_HEADER_LEN 4
-#define CMDMBOX_INFO_ELEM_HEADER_LEN 4
-
-
-struct basic_scan_parameters {
-	u32 rx_config_options;
-	u32 rx_filter_options;
-
-	/*
-	 * Scan options:
-	 * bit 0: When this bit is set, passive scan.
-	 * bit 1: Band, when this bit is set we scan
-	 * in the 5Ghz band.
-	 * bit 2: voice mode, 0 for normal scan.
-	 * bit 3: scan priority, 1 for high priority.
-	 */
-	u16 scan_options;
-
-	/* Number of channels to scan */
-	u8 num_channels;
-
-	/* Number opf probe requests to send, per channel */
-	u8 num_probe_requests;
-
-	/* Rate and modulation for probe requests */
-	u16 tx_rate;
-
-	u8 tid_trigger;
-	u8 ssid_len;
-	u32 ssid[8];
-
-} __attribute__ ((packed));
-
-struct basic_scan_channel_parameters {
-	u32 min_duration; /* in TU */
-	u32 max_duration; /* in TU */
-	u32 bssid_lsb;
-	u16 bssid_msb;
-
-	/*
-	 * bits 0-3: Early termination count.
-	 * bits 4-5: Early termination condition.
-	 */
-	u8 early_termination;
-
-	u8 tx_power_att;
-	u8 channel;
-	u8 pad[3];
-} __attribute__ ((packed));
-
-/* SCAN parameters */
-#define SCAN_MAX_NUM_OF_CHANNELS 16
-
-struct cmd_scan {
-	struct wl12xx_cmd_header header;
-
-	struct basic_scan_parameters params;
-	struct basic_scan_channel_parameters channels[SCAN_MAX_NUM_OF_CHANNELS];
-} __attribute__ ((packed));
-
-enum {
-	BSS_TYPE_IBSS = 0,
-	BSS_TYPE_STA_BSS = 2,
-	BSS_TYPE_AP_BSS = 3,
-	MAX_BSS_TYPE = 0xFF
-};
-
-#define JOIN_CMD_CTRL_TX_FLUSH             0x80 /* Firmware flushes all Tx */
-#define JOIN_CMD_CTRL_EARLY_WAKEUP_ENABLE  0x01 /* Early wakeup time */
-
-
-struct cmd_join {
-	struct wl12xx_cmd_header header;
-
-	u32 bssid_lsb;
-	u16 bssid_msb;
-	u16 beacon_interval; /* in TBTTs */
-	u32 rx_config_options;
-	u32 rx_filter_options;
-
-	/*
-	 * The target uses this field to determine the rate at
-	 * which to transmit control frame responses (such as
-	 * ACK or CTS frames).
-	 */
-	u16 basic_rate_set;
-	u8 dtim_interval;
-	u8 tx_ctrl_frame_rate; /* OBSOLETE */
-	u8 tx_ctrl_frame_mod;  /* OBSOLETE */
-	/*
-	 * bits 0-2: This bitwise field specifies the type
-	 * of BSS to start or join (BSS_TYPE_*).
-	 * bit 4: Band - The radio band in which to join
-	 * or start.
-	 *  0 - 2.4GHz band
-	 *  1 - 5GHz band
-	 * bits 3, 5-7: Reserved
-	 */
-	u8 bss_type;
-	u8 channel;
-	u8 ssid_len;
-	u8 ssid[IW_ESSID_MAX_SIZE];
-	u8 ctrl; /* JOIN_CMD_CTRL_* */
-	u8 tx_mgt_frame_rate; /* OBSOLETE */
-	u8 tx_mgt_frame_mod;  /* OBSOLETE */
-	u8 reserved;
-} __attribute__ ((packed));
-
-struct cmd_enabledisable_path {
-	struct wl12xx_cmd_header header;
-
-	u8 channel;
-	u8 padding[3];
-} __attribute__ ((packed));
-
-#define WL12XX_MAX_TEMPLATE_SIZE 300
-
-struct wl12xx_cmd_packet_template {
-	struct wl12xx_cmd_header header;
-
-	__le16 size;
-	u8 data[0];
-} __attribute__ ((packed));
-
-#define TIM_ELE_ID    5
-#define PARTIAL_VBM_MAX    251
-
-struct wl12xx_tim {
-	u8 identity;
-	u8 length;
-	u8 dtim_count;
-	u8 dtim_period;
-	u8 bitmap_ctrl;
-	u8 pvb_field[PARTIAL_VBM_MAX]; /* Partial Virtual Bitmap */
-} __attribute__ ((packed));
-
-/* Virtual Bit Map update */
-struct wl12xx_cmd_vbm_update {
-	struct wl12xx_cmd_header header;
-	__le16 len;
-	u8  padding[2];
-	struct wl12xx_tim tim;
-} __attribute__ ((packed));
-
-enum wl12xx_cmd_ps_mode {
-	STATION_ACTIVE_MODE,
-	STATION_POWER_SAVE_MODE
-};
-
-struct wl12xx_cmd_ps_params {
-	struct wl12xx_cmd_header header;
-
-	u8 ps_mode; /* STATION_* */
-	u8 send_null_data; /* Do we have to send NULL data packet ? */
-	u8 retries; /* Number of retires for the initial NULL data packet */
-
-	 /*
-	  * TUs during which the target stays awake after switching
-	  * to power save mode.
-	  */
-	u8 hang_over_period;
-	u16 null_data_rate;
-	u8 pad[2];
-} __attribute__ ((packed));
-
-struct wl12xx_cmd_trigger_scan_to {
-	struct wl12xx_cmd_header header;
-
-	u32 timeout;
-};
-
-/* HW encryption keys */
-#define NUM_ACCESS_CATEGORIES_COPY 4
-#define MAX_KEY_SIZE 32
-
-/* When set, disable HW encryption */
-#define DF_ENCRYPTION_DISABLE      0x01
-/* When set, disable HW decryption */
-#define DF_SNIFF_MODE_ENABLE       0x80
-
-enum wl12xx_cmd_key_action {
-	KEY_ADD_OR_REPLACE = 1,
-	KEY_REMOVE         = 2,
-	KEY_SET_ID         = 3,
-	MAX_KEY_ACTION     = 0xffff,
-};
-
-enum wl12xx_cmd_key_type {
-	KEY_WEP_DEFAULT       = 0,
-	KEY_WEP_ADDR          = 1,
-	KEY_AES_GROUP         = 4,
-	KEY_AES_PAIRWISE      = 5,
-	KEY_WEP_GROUP         = 6,
-	KEY_TKIP_MIC_GROUP    = 10,
-	KEY_TKIP_MIC_PAIRWISE = 11,
-};
-
-/*
- *
- * key_type_e   key size    key format
- * ----------   ---------   ----------
- * 0x00         5, 13, 29   Key data
- * 0x01         5, 13, 29   Key data
- * 0x04         16          16 bytes of key data
- * 0x05         16          16 bytes of key data
- * 0x0a         32          16 bytes of TKIP key data
- *                          8 bytes of RX MIC key data
- *                          8 bytes of TX MIC key data
- * 0x0b         32          16 bytes of TKIP key data
- *                          8 bytes of RX MIC key data
- *                          8 bytes of TX MIC key data
- *
- */
-
-struct wl12xx_cmd_set_keys {
-	struct wl12xx_cmd_header header;
-
-	/* Ignored for default WEP key */
-	u8 addr[ETH_ALEN];
-
-	/* key_action_e */
-	u16 key_action;
-
-	u16 reserved_1;
-
-	/* key size in bytes */
-	u8 key_size;
-
-	/* key_type_e */
-	u8 key_type;
-	u8 ssid_profile;
-
-	/*
-	 * TKIP, AES: frame's key id field.
-	 * For WEP default key: key id;
-	 */
-	u8 id;
-	u8 reserved_2[6];
-	u8 key[MAX_KEY_SIZE];
-	u16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
-	u32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
-} __attribute__ ((packed));
-
-
-#endif /* __WL12XX_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
deleted file mode 100644
index 94ad994..0000000
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ /dev/null
@@ -1,518 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include "debugfs.h"
-
-#include <linux/skbuff.h>
-
-#include "wl12xx.h"
-#include "acx.h"
-#include "ps.h"
-
-/* ms */
-#define WL12XX_DEBUGFS_STATS_LIFETIME 1000
-
-/* debugfs macros idea from mac80211 */
-
-#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
-static ssize_t name## _read(struct file *file, char __user *userbuf,	\
-			    size_t count, loff_t *ppos)			\
-{									\
-	struct wl12xx *wl = file->private_data;				\
-	char buf[buflen];						\
-	int res;							\
-									\
-	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
-}									\
-									\
-static const struct file_operations name## _ops = {			\
-	.read = name## _read,						\
-	.open = wl12xx_open_file_generic,				\
-};
-
-#define DEBUGFS_ADD(name, parent)					\
-	wl->debugfs.name = debugfs_create_file(#name, 0400, parent,	\
-					       wl, &name## _ops);	\
-	if (IS_ERR(wl->debugfs.name)) {					\
-		ret = PTR_ERR(wl->debugfs.name);			\
-		wl->debugfs.name = NULL;				\
-		goto out;						\
-	}
-
-#define DEBUGFS_DEL(name)						\
-	do {								\
-		debugfs_remove(wl->debugfs.name);			\
-		wl->debugfs.name = NULL;				\
-	} while (0)
-
-#define DEBUGFS_FWSTATS_FILE(sub, name, buflen, fmt)			\
-static ssize_t sub## _ ##name## _read(struct file *file,		\
-				      char __user *userbuf,		\
-				      size_t count, loff_t *ppos)	\
-{									\
-	struct wl12xx *wl = file->private_data;				\
-	char buf[buflen];						\
-	int res;							\
-									\
-	wl12xx_debugfs_update_stats(wl);				\
-									\
-	res = scnprintf(buf, buflen, fmt "\n",				\
-			wl->stats.fw_stats->sub.name);			\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
-}									\
-									\
-static const struct file_operations sub## _ ##name## _ops = {		\
-	.read = sub## _ ##name## _read,					\
-	.open = wl12xx_open_file_generic,				\
-};
-
-#define DEBUGFS_FWSTATS_ADD(sub, name)				\
-	DEBUGFS_ADD(sub## _ ##name, wl->debugfs.fw_statistics)
-
-#define DEBUGFS_FWSTATS_DEL(sub, name)				\
-	DEBUGFS_DEL(sub## _ ##name)
-
-static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
-{
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	if (wl->state == WL12XX_STATE_ON &&
-	    time_after(jiffies, wl->stats.fw_stats_update +
-		       msecs_to_jiffies(WL12XX_DEBUGFS_STATS_LIFETIME))) {
-		wl12xx_acx_statistics(wl, wl->stats.fw_stats);
-		wl->stats.fw_stats_update = jiffies;
-	}
-
-	wl12xx_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-}
-
-static int wl12xx_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(rx, out_of_mem, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, hw_stuck, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, dropped, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, fcs_err, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, path_reset, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, reset_counter, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(dma, rx_requested, 20, "%u");
-DEBUGFS_FWSTATS_FILE(dma, rx_errors, 20, "%u");
-DEBUGFS_FWSTATS_FILE(dma, tx_requested, 20, "%u");
-DEBUGFS_FWSTATS_FILE(dma, tx_errors, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, fiqs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_headers, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_rdys, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, irqs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, tx_procs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, decrypt_done, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, dma0_done, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, dma1_done, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, commands, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_procs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, pci_pm, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, wakeups, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, low_rssi, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(wep, addr_key_count, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, default_key_count, 20, "%u");
-/* skipping wep.reserved */
-DEBUGFS_FWSTATS_FILE(wep, key_not_found, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, packets, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, interrupt, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(pwr, ps_enter, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, elp_enter, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, power_save_off, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, enable_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, disable_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, 20, "%u");
-/* skipping cont_miss_bcns_spread for now */
-DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(mic, rx_pkts, 20, "%u");
-DEBUGFS_FWSTATS_FILE(mic, calc_failure, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(event, heart_beat, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, calibration, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_mismatch, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_pool, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, oom_late, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, tx_stuck, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data,
-		     20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, 20, "%u");
-
-DEBUGFS_READONLY_FILE(retry_count, 20, "%u", wl->stats.retry_count);
-DEBUGFS_READONLY_FILE(excessive_retries, 20, "%u",
-		      wl->stats.excessive_retries);
-
-static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
-				 size_t count, loff_t *ppos)
-{
-	struct wl12xx *wl = file->private_data;
-	u32 queue_len;
-	char buf[20];
-	int res;
-
-	queue_len = skb_queue_len(&wl->tx_queue);
-
-	res = scnprintf(buf, sizeof(buf), "%u\n", queue_len);
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-
-static const struct file_operations tx_queue_len_ops = {
-	.read = tx_queue_len_read,
-	.open = wl12xx_open_file_generic,
-};
-
-static void wl12xx_debugfs_delete_files(struct wl12xx *wl)
-{
-	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
-
-	DEBUGFS_FWSTATS_DEL(rx, out_of_mem);
-	DEBUGFS_FWSTATS_DEL(rx, hdr_overflow);
-	DEBUGFS_FWSTATS_DEL(rx, hw_stuck);
-	DEBUGFS_FWSTATS_DEL(rx, dropped);
-	DEBUGFS_FWSTATS_DEL(rx, fcs_err);
-	DEBUGFS_FWSTATS_DEL(rx, xfr_hint_trig);
-	DEBUGFS_FWSTATS_DEL(rx, path_reset);
-	DEBUGFS_FWSTATS_DEL(rx, reset_counter);
-
-	DEBUGFS_FWSTATS_DEL(dma, rx_requested);
-	DEBUGFS_FWSTATS_DEL(dma, rx_errors);
-	DEBUGFS_FWSTATS_DEL(dma, tx_requested);
-	DEBUGFS_FWSTATS_DEL(dma, tx_errors);
-
-	DEBUGFS_FWSTATS_DEL(isr, cmd_cmplt);
-	DEBUGFS_FWSTATS_DEL(isr, fiqs);
-	DEBUGFS_FWSTATS_DEL(isr, rx_headers);
-	DEBUGFS_FWSTATS_DEL(isr, rx_mem_overflow);
-	DEBUGFS_FWSTATS_DEL(isr, rx_rdys);
-	DEBUGFS_FWSTATS_DEL(isr, irqs);
-	DEBUGFS_FWSTATS_DEL(isr, tx_procs);
-	DEBUGFS_FWSTATS_DEL(isr, decrypt_done);
-	DEBUGFS_FWSTATS_DEL(isr, dma0_done);
-	DEBUGFS_FWSTATS_DEL(isr, dma1_done);
-	DEBUGFS_FWSTATS_DEL(isr, tx_exch_complete);
-	DEBUGFS_FWSTATS_DEL(isr, commands);
-	DEBUGFS_FWSTATS_DEL(isr, rx_procs);
-	DEBUGFS_FWSTATS_DEL(isr, hw_pm_mode_changes);
-	DEBUGFS_FWSTATS_DEL(isr, host_acknowledges);
-	DEBUGFS_FWSTATS_DEL(isr, pci_pm);
-	DEBUGFS_FWSTATS_DEL(isr, wakeups);
-	DEBUGFS_FWSTATS_DEL(isr, low_rssi);
-
-	DEBUGFS_FWSTATS_DEL(wep, addr_key_count);
-	DEBUGFS_FWSTATS_DEL(wep, default_key_count);
-	/* skipping wep.reserved */
-	DEBUGFS_FWSTATS_DEL(wep, key_not_found);
-	DEBUGFS_FWSTATS_DEL(wep, decrypt_fail);
-	DEBUGFS_FWSTATS_DEL(wep, packets);
-	DEBUGFS_FWSTATS_DEL(wep, interrupt);
-
-	DEBUGFS_FWSTATS_DEL(pwr, ps_enter);
-	DEBUGFS_FWSTATS_DEL(pwr, elp_enter);
-	DEBUGFS_FWSTATS_DEL(pwr, missing_bcns);
-	DEBUGFS_FWSTATS_DEL(pwr, wake_on_host);
-	DEBUGFS_FWSTATS_DEL(pwr, wake_on_timer_exp);
-	DEBUGFS_FWSTATS_DEL(pwr, tx_with_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, tx_without_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, rcvd_beacons);
-	DEBUGFS_FWSTATS_DEL(pwr, power_save_off);
-	DEBUGFS_FWSTATS_DEL(pwr, enable_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, disable_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, fix_tsf_ps);
-	/* skipping cont_miss_bcns_spread for now */
-	DEBUGFS_FWSTATS_DEL(pwr, rcvd_awake_beacons);
-
-	DEBUGFS_FWSTATS_DEL(mic, rx_pkts);
-	DEBUGFS_FWSTATS_DEL(mic, calc_failure);
-
-	DEBUGFS_FWSTATS_DEL(aes, encrypt_fail);
-	DEBUGFS_FWSTATS_DEL(aes, decrypt_fail);
-	DEBUGFS_FWSTATS_DEL(aes, encrypt_packets);
-	DEBUGFS_FWSTATS_DEL(aes, decrypt_packets);
-	DEBUGFS_FWSTATS_DEL(aes, encrypt_interrupt);
-	DEBUGFS_FWSTATS_DEL(aes, decrypt_interrupt);
-
-	DEBUGFS_FWSTATS_DEL(event, heart_beat);
-	DEBUGFS_FWSTATS_DEL(event, calibration);
-	DEBUGFS_FWSTATS_DEL(event, rx_mismatch);
-	DEBUGFS_FWSTATS_DEL(event, rx_mem_empty);
-	DEBUGFS_FWSTATS_DEL(event, rx_pool);
-	DEBUGFS_FWSTATS_DEL(event, oom_late);
-	DEBUGFS_FWSTATS_DEL(event, phy_transmit_error);
-	DEBUGFS_FWSTATS_DEL(event, tx_stuck);
-
-	DEBUGFS_FWSTATS_DEL(ps, pspoll_timeouts);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_timeouts);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_max_sptime);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_max_apturn);
-	DEBUGFS_FWSTATS_DEL(ps, pspoll_max_apturn);
-	DEBUGFS_FWSTATS_DEL(ps, pspoll_utilization);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_utilization);
-
-	DEBUGFS_FWSTATS_DEL(rxpipe, rx_prep_beacon_drop);
-	DEBUGFS_FWSTATS_DEL(rxpipe, descr_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_DEL(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_DEL(rxpipe, missed_beacon_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_DEL(rxpipe, tx_xfr_host_int_trig_rx_data);
-
-	DEBUGFS_DEL(tx_queue_len);
-	DEBUGFS_DEL(retry_count);
-	DEBUGFS_DEL(excessive_retries);
-}
-
-static int wl12xx_debugfs_add_files(struct wl12xx *wl)
-{
-	int ret = 0;
-
-	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
-
-	DEBUGFS_FWSTATS_ADD(rx, out_of_mem);
-	DEBUGFS_FWSTATS_ADD(rx, hdr_overflow);
-	DEBUGFS_FWSTATS_ADD(rx, hw_stuck);
-	DEBUGFS_FWSTATS_ADD(rx, dropped);
-	DEBUGFS_FWSTATS_ADD(rx, fcs_err);
-	DEBUGFS_FWSTATS_ADD(rx, xfr_hint_trig);
-	DEBUGFS_FWSTATS_ADD(rx, path_reset);
-	DEBUGFS_FWSTATS_ADD(rx, reset_counter);
-
-	DEBUGFS_FWSTATS_ADD(dma, rx_requested);
-	DEBUGFS_FWSTATS_ADD(dma, rx_errors);
-	DEBUGFS_FWSTATS_ADD(dma, tx_requested);
-	DEBUGFS_FWSTATS_ADD(dma, tx_errors);
-
-	DEBUGFS_FWSTATS_ADD(isr, cmd_cmplt);
-	DEBUGFS_FWSTATS_ADD(isr, fiqs);
-	DEBUGFS_FWSTATS_ADD(isr, rx_headers);
-	DEBUGFS_FWSTATS_ADD(isr, rx_mem_overflow);
-	DEBUGFS_FWSTATS_ADD(isr, rx_rdys);
-	DEBUGFS_FWSTATS_ADD(isr, irqs);
-	DEBUGFS_FWSTATS_ADD(isr, tx_procs);
-	DEBUGFS_FWSTATS_ADD(isr, decrypt_done);
-	DEBUGFS_FWSTATS_ADD(isr, dma0_done);
-	DEBUGFS_FWSTATS_ADD(isr, dma1_done);
-	DEBUGFS_FWSTATS_ADD(isr, tx_exch_complete);
-	DEBUGFS_FWSTATS_ADD(isr, commands);
-	DEBUGFS_FWSTATS_ADD(isr, rx_procs);
-	DEBUGFS_FWSTATS_ADD(isr, hw_pm_mode_changes);
-	DEBUGFS_FWSTATS_ADD(isr, host_acknowledges);
-	DEBUGFS_FWSTATS_ADD(isr, pci_pm);
-	DEBUGFS_FWSTATS_ADD(isr, wakeups);
-	DEBUGFS_FWSTATS_ADD(isr, low_rssi);
-
-	DEBUGFS_FWSTATS_ADD(wep, addr_key_count);
-	DEBUGFS_FWSTATS_ADD(wep, default_key_count);
-	/* skipping wep.reserved */
-	DEBUGFS_FWSTATS_ADD(wep, key_not_found);
-	DEBUGFS_FWSTATS_ADD(wep, decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(wep, packets);
-	DEBUGFS_FWSTATS_ADD(wep, interrupt);
-
-	DEBUGFS_FWSTATS_ADD(pwr, ps_enter);
-	DEBUGFS_FWSTATS_ADD(pwr, elp_enter);
-	DEBUGFS_FWSTATS_ADD(pwr, missing_bcns);
-	DEBUGFS_FWSTATS_ADD(pwr, wake_on_host);
-	DEBUGFS_FWSTATS_ADD(pwr, wake_on_timer_exp);
-	DEBUGFS_FWSTATS_ADD(pwr, tx_with_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, tx_without_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, rcvd_beacons);
-	DEBUGFS_FWSTATS_ADD(pwr, power_save_off);
-	DEBUGFS_FWSTATS_ADD(pwr, enable_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, disable_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, fix_tsf_ps);
-	/* skipping cont_miss_bcns_spread for now */
-	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_beacons);
-
-	DEBUGFS_FWSTATS_ADD(mic, rx_pkts);
-	DEBUGFS_FWSTATS_ADD(mic, calc_failure);
-
-	DEBUGFS_FWSTATS_ADD(aes, encrypt_fail);
-	DEBUGFS_FWSTATS_ADD(aes, decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(aes, encrypt_packets);
-	DEBUGFS_FWSTATS_ADD(aes, decrypt_packets);
-	DEBUGFS_FWSTATS_ADD(aes, encrypt_interrupt);
-	DEBUGFS_FWSTATS_ADD(aes, decrypt_interrupt);
-
-	DEBUGFS_FWSTATS_ADD(event, heart_beat);
-	DEBUGFS_FWSTATS_ADD(event, calibration);
-	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
-	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
-	DEBUGFS_FWSTATS_ADD(event, rx_pool);
-	DEBUGFS_FWSTATS_ADD(event, oom_late);
-	DEBUGFS_FWSTATS_ADD(event, phy_transmit_error);
-	DEBUGFS_FWSTATS_ADD(event, tx_stuck);
-
-	DEBUGFS_FWSTATS_ADD(ps, pspoll_timeouts);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_timeouts);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_max_sptime);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_max_apturn);
-	DEBUGFS_FWSTATS_ADD(ps, pspoll_max_apturn);
-	DEBUGFS_FWSTATS_ADD(ps, pspoll_utilization);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_utilization);
-
-	DEBUGFS_FWSTATS_ADD(rxpipe, rx_prep_beacon_drop);
-	DEBUGFS_FWSTATS_ADD(rxpipe, descr_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_ADD(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_ADD(rxpipe, missed_beacon_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
-
-	DEBUGFS_ADD(tx_queue_len, wl->debugfs.rootdir);
-	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
-	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
-
-out:
-	if (ret < 0)
-		wl12xx_debugfs_delete_files(wl);
-
-	return ret;
-}
-
-void wl12xx_debugfs_reset(struct wl12xx *wl)
-{
-	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
-	wl->stats.retry_count = 0;
-	wl->stats.excessive_retries = 0;
-}
-
-int wl12xx_debugfs_init(struct wl12xx *wl)
-{
-	int ret;
-
-	wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
-
-	if (IS_ERR(wl->debugfs.rootdir)) {
-		ret = PTR_ERR(wl->debugfs.rootdir);
-		wl->debugfs.rootdir = NULL;
-		goto err;
-	}
-
-	wl->debugfs.fw_statistics = debugfs_create_dir("fw-statistics",
-						       wl->debugfs.rootdir);
-
-	if (IS_ERR(wl->debugfs.fw_statistics)) {
-		ret = PTR_ERR(wl->debugfs.fw_statistics);
-		wl->debugfs.fw_statistics = NULL;
-		goto err_root;
-	}
-
-	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats),
-				      GFP_KERNEL);
-
-	if (!wl->stats.fw_stats) {
-		ret = -ENOMEM;
-		goto err_fw;
-	}
-
-	wl->stats.fw_stats_update = jiffies;
-
-	ret = wl12xx_debugfs_add_files(wl);
-
-	if (ret < 0)
-		goto err_file;
-
-	return 0;
-
-err_file:
-	kfree(wl->stats.fw_stats);
-	wl->stats.fw_stats = NULL;
-
-err_fw:
-	debugfs_remove(wl->debugfs.fw_statistics);
-	wl->debugfs.fw_statistics = NULL;
-
-err_root:
-	debugfs_remove(wl->debugfs.rootdir);
-	wl->debugfs.rootdir = NULL;
-
-err:
-	return ret;
-}
-
-void wl12xx_debugfs_exit(struct wl12xx *wl)
-{
-	wl12xx_debugfs_delete_files(wl);
-
-	kfree(wl->stats.fw_stats);
-	wl->stats.fw_stats = NULL;
-
-	debugfs_remove(wl->debugfs.fw_statistics);
-	wl->debugfs.fw_statistics = NULL;
-
-	debugfs_remove(wl->debugfs.rootdir);
-	wl->debugfs.rootdir = NULL;
-
-}
diff --git a/drivers/net/wireless/wl12xx/debugfs.h b/drivers/net/wireless/wl12xx/debugfs.h
deleted file mode 100644
index 562cdcb..0000000
--- a/drivers/net/wireless/wl12xx/debugfs.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef WL12XX_DEBUGFS_H
-#define WL12XX_DEBUGFS_H
-
-#include "wl12xx.h"
-
-int wl12xx_debugfs_init(struct wl12xx *wl);
-void wl12xx_debugfs_exit(struct wl12xx *wl);
-void wl12xx_debugfs_reset(struct wl12xx *wl);
-
-#endif /* WL12XX_DEBUGFS_H */
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
deleted file mode 100644
index 99529ca..0000000
--- a/drivers/net/wireless/wl12xx/event.c
+++ /dev/null
@@ -1,127 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include "wl12xx.h"
-#include "reg.h"
-#include "spi.h"
-#include "event.h"
-#include "ps.h"
-
-static int wl12xx_event_scan_complete(struct wl12xx *wl,
-				      struct event_mailbox *mbox)
-{
-	wl12xx_debug(DEBUG_EVENT, "status: 0x%x, channels: %d",
-		     mbox->scheduled_scan_status,
-		     mbox->scheduled_scan_channels);
-
-	if (wl->scanning) {
-		mutex_unlock(&wl->mutex);
-		ieee80211_scan_completed(wl->hw, false);
-		mutex_lock(&wl->mutex);
-		wl->scanning = false;
-	}
-
-	return 0;
-}
-
-static void wl12xx_event_mbox_dump(struct event_mailbox *mbox)
-{
-	wl12xx_debug(DEBUG_EVENT, "MBOX DUMP:");
-	wl12xx_debug(DEBUG_EVENT, "\tvector: 0x%x", mbox->events_vector);
-	wl12xx_debug(DEBUG_EVENT, "\tmask: 0x%x", mbox->events_mask);
-}
-
-static int wl12xx_event_process(struct wl12xx *wl, struct event_mailbox *mbox)
-{
-	int ret;
-	u32 vector;
-
-	wl12xx_event_mbox_dump(mbox);
-
-	vector = mbox->events_vector & ~(mbox->events_mask);
-	wl12xx_debug(DEBUG_EVENT, "vector: 0x%x", vector);
-
-	if (vector & SCAN_COMPLETE_EVENT_ID) {
-		ret = wl12xx_event_scan_complete(wl, mbox);
-		if (ret < 0)
-			return ret;
-	}
-
-	if (vector & BSS_LOSE_EVENT_ID) {
-		wl12xx_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
-
-		if (wl->psm_requested && wl->psm) {
-			ret = wl12xx_ps_set_mode(wl, STATION_ACTIVE_MODE);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	return 0;
-}
-
-int wl12xx_event_unmask(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_event_mbox_mask(wl, ~(wl->event_mask));
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-void wl12xx_event_mbox_config(struct wl12xx *wl)
-{
-	wl->mbox_ptr[0] = wl12xx_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
-	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
-
-	wl12xx_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
-		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
-}
-
-int wl12xx_event_handle(struct wl12xx *wl, u8 mbox_num)
-{
-	struct event_mailbox mbox;
-	int ret;
-
-	wl12xx_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
-
-	if (mbox_num > 1)
-		return -EINVAL;
-
-	/* first we read the mbox descriptor */
-	wl12xx_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
-			    sizeof(struct event_mailbox));
-
-	/* process the descriptor */
-	ret = wl12xx_event_process(wl, &mbox);
-	if (ret < 0)
-		return ret;
-
-	/* then we let the firmware know it can go on...*/
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
-
-	return 0;
-}
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
deleted file mode 100644
index 1f4c2f7..0000000
--- a/drivers/net/wireless/wl12xx/event.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_EVENT_H__
-#define __WL12XX_EVENT_H__
-
-/*
- * Mbox events
- *
- * The event mechanism is based on a pair of event buffers (buffers A and
- * B) at fixed locations in the target's memory. The host processes one
- * buffer while the other buffer continues to collect events. If the host
- * is not processing events, an interrupt is issued to signal that a buffer
- * is ready. Once the host is done with processing events from one buffer,
- * it signals the target (with an ACK interrupt) that the event buffer is
- * free.
- */
-
-enum {
-	RESERVED1_EVENT_ID                       = BIT(0),
-	RESERVED2_EVENT_ID                       = BIT(1),
-	MEASUREMENT_START_EVENT_ID               = BIT(2),
-	SCAN_COMPLETE_EVENT_ID                   = BIT(3),
-	CALIBRATION_COMPLETE_EVENT_ID            = BIT(4),
-	ROAMING_TRIGGER_LOW_RSSI_EVENT_ID        = BIT(5),
-	PS_REPORT_EVENT_ID                       = BIT(6),
-	SYNCHRONIZATION_TIMEOUT_EVENT_ID         = BIT(7),
-	HEALTH_REPORT_EVENT_ID                   = BIT(8),
-	ACI_DETECTION_EVENT_ID                   = BIT(9),
-	DEBUG_REPORT_EVENT_ID                    = BIT(10),
-	MAC_STATUS_EVENT_ID                      = BIT(11),
-	DISCONNECT_EVENT_COMPLETE_ID             = BIT(12),
-	JOIN_EVENT_COMPLETE_ID                   = BIT(13),
-	CHANNEL_SWITCH_COMPLETE_EVENT_ID         = BIT(14),
-	BSS_LOSE_EVENT_ID                        = BIT(15),
-	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID    = BIT(16),
-	MEASUREMENT_COMPLETE_EVENT_ID            = BIT(17),
-	AP_DISCOVERY_COMPLETE_EVENT_ID           = BIT(18),
-	SCHEDULED_SCAN_COMPLETE_EVENT_ID         = BIT(19),
-	PSPOLL_DELIVERY_FAILURE_EVENT_ID 	 = BIT(20),
-	RESET_BSS_EVENT_ID                       = BIT(21),
-	REGAINED_BSS_EVENT_ID                    = BIT(22),
-	ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID   = BIT(23),
-	ROAMING_TRIGGER_LOW_SNR_EVENT_ID         = BIT(24),
-	ROAMING_TRIGGER_REGAINED_SNR_EVENT_ID    = BIT(25),
-
-	DBG_EVENT_ID                             = BIT(26),
-	BT_PTA_SENSE_EVENT_ID                    = BIT(27),
-	BT_PTA_PREDICTION_EVENT_ID               = BIT(28),
-	BT_PTA_AVALANCHE_EVENT_ID                = BIT(29),
-
-	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID     = BIT(30),
-
-	EVENT_MBOX_ALL_EVENT_ID                  = 0x7fffffff,
-};
-
-struct event_debug_report {
-	u8 debug_event_id;
-	u8 num_params;
-	u16 pad;
-	u32 report_1;
-	u32 report_2;
-	u32 report_3;
-} __attribute__ ((packed));
-
-struct event_mailbox {
-	u32 events_vector;
-	u32 events_mask;
-	u32 reserved_1;
-	u32 reserved_2;
-
-	char average_rssi_level;
-	u8 ps_status;
-	u8 channel_switch_status;
-	u8 scheduled_scan_status;
-
-	/* Channels scanned by the scheduled scan */
-	u16 scheduled_scan_channels;
-
-	/* If bit 0 is set -> target's fatal error */
-	u16 health_report;
-	u16 bad_fft_counter;
-	u8 bt_pta_sense_info;
-	u8 bt_pta_protective_info;
-	u32 reserved;
-	u32 debug_report[2];
-
-	/* Number of FCS errors since last event */
-	u32 fcs_err_counter;
-
-	struct event_debug_report report;
-	u8 average_snr_level;
-	u8 padding[19];
-} __attribute__ ((packed));
-
-int wl12xx_event_unmask(struct wl12xx *wl);
-void wl12xx_event_mbox_config(struct wl12xx *wl);
-int wl12xx_event_handle(struct wl12xx *wl, u8 mbox);
-
-#endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
deleted file mode 100644
index 2a573a6..0000000
--- a/drivers/net/wireless/wl12xx/init.c
+++ /dev/null
@@ -1,200 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include "init.h"
-#include "wl12xx_80211.h"
-#include "acx.h"
-#include "cmd.h"
-
-int wl12xx_hw_init_hwenc_config(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_feature_cfg(wl);
-	if (ret < 0) {
-		wl12xx_warning("couldn't set feature config");
-		return ret;
-	}
-
-	ret = wl12xx_acx_default_key(wl, wl->default_key);
-	if (ret < 0) {
-		wl12xx_warning("couldn't set default key");
-		return ret;
-	}
-
-	return 0;
-}
-
-int wl12xx_hw_init_templates_config(struct wl12xx *wl)
-{
-	int ret;
-	u8 partial_vbm[PARTIAL_VBM_MAX];
-
-	/* send empty templates for fw memory reservation */
-	ret = wl12xx_cmd_template_set(wl, CMD_PROBE_REQ, NULL,
-				      sizeof(struct wl12xx_probe_req_template));
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_cmd_template_set(wl, CMD_NULL_DATA, NULL,
-				      sizeof(struct wl12xx_null_data_template));
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_cmd_template_set(wl, CMD_PS_POLL, NULL,
-				      sizeof(struct wl12xx_ps_poll_template));
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_cmd_template_set(wl, CMD_QOS_NULL_DATA, NULL,
-				      sizeof
-				      (struct wl12xx_qos_null_data_template));
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, NULL,
-				      sizeof
-				      (struct wl12xx_probe_resp_template));
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_cmd_template_set(wl, CMD_BEACON, NULL,
-				      sizeof
-				      (struct wl12xx_beacon_template));
-	if (ret < 0)
-		return ret;
-
-	/* tim templates, first reserve space then allocate an empty one */
-	memset(partial_vbm, 0, PARTIAL_VBM_MAX);
-	ret = wl12xx_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, PARTIAL_VBM_MAX, 0);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, 1, 0);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter)
-{
-	int ret;
-
-	ret = wl12xx_acx_rx_msdu_life_time(wl, RX_MSDU_LIFETIME_DEF);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_rx_config(wl, config, filter);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_phy_config(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_pd_threshold(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_slot(wl, DEFAULT_SLOT_TIME);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_group_address_tbl(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_service_period_timeout(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_rts_threshold(wl, RTS_THRESHOLD_DEF);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_beacon_filter(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_beacon_filter_opt(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_beacon_filter_table(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_pta(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_sg_enable(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_acx_sg_cfg(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_energy_detection(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_cca_threshold(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_beacon_broadcast(struct wl12xx *wl)
-{
-	int ret;
-
-	ret = wl12xx_acx_bcn_dtim_options(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_hw_init_power_auth(struct wl12xx *wl)
-{
-	return wl12xx_acx_sleep_auth(wl, WL12XX_PSM_CAM);
-}
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
deleted file mode 100644
index c8b6cd0..0000000
--- a/drivers/net/wireless/wl12xx/init.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_INIT_H__
-#define __WL12XX_INIT_H__
-
-#include "wl12xx.h"
-
-int wl12xx_hw_init_hwenc_config(struct wl12xx *wl);
-int wl12xx_hw_init_templates_config(struct wl12xx *wl);
-int wl12xx_hw_init_mem_config(struct wl12xx *wl);
-int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter);
-int wl12xx_hw_init_phy_config(struct wl12xx *wl);
-int wl12xx_hw_init_beacon_filter(struct wl12xx *wl);
-int wl12xx_hw_init_pta(struct wl12xx *wl);
-int wl12xx_hw_init_energy_detection(struct wl12xx *wl);
-int wl12xx_hw_init_beacon_broadcast(struct wl12xx *wl);
-int wl12xx_hw_init_power_auth(struct wl12xx *wl);
-
-#endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
deleted file mode 100644
index dd75d3d..0000000
--- a/drivers/net/wireless/wl12xx/main.c
+++ /dev/null
@@ -1,1442 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2008-2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/firmware.h>
-#include <linux/delay.h>
-#include <linux/irq.h>
-#include <linux/spi/spi.h>
-#include <linux/crc32.h>
-#include <linux/etherdevice.h>
-#include <linux/spi/wl12xx.h>
-
-#include "wl12xx.h"
-#include "wl12xx_80211.h"
-#include "reg.h"
-#include "wl1251_ops.h"
-#include "spi.h"
-#include "event.h"
-#include "wl1251_tx.h"
-#include "rx.h"
-#include "ps.h"
-#include "init.h"
-#include "debugfs.h"
-
-static void wl12xx_disable_interrupts(struct wl12xx *wl)
-{
-	disable_irq(wl->irq);
-}
-
-static void wl12xx_power_off(struct wl12xx *wl)
-{
-	wl->set_power(false);
-}
-
-static void wl12xx_power_on(struct wl12xx *wl)
-{
-	wl->set_power(true);
-}
-
-static irqreturn_t wl12xx_irq(int irq, void *cookie)
-{
-	struct wl12xx *wl;
-
-	wl12xx_debug(DEBUG_IRQ, "IRQ");
-
-	wl = cookie;
-
-	schedule_work(&wl->irq_work);
-
-	return IRQ_HANDLED;
-}
-
-static int wl12xx_fetch_firmware(struct wl12xx *wl)
-{
-	const struct firmware *fw;
-	int ret;
-
-	ret = request_firmware(&fw, wl->chip.fw_filename, &wl->spi->dev);
-
-	if (ret < 0) {
-		wl12xx_error("could not get firmware: %d", ret);
-		return ret;
-	}
-
-	if (fw->size % 4) {
-		wl12xx_error("firmware size is not multiple of 32 bits: %zu",
-			     fw->size);
-		ret = -EILSEQ;
-		goto out;
-	}
-
-	wl->fw_len = fw->size;
-	wl->fw = kmalloc(wl->fw_len, GFP_KERNEL);
-
-	if (!wl->fw) {
-		wl12xx_error("could not allocate memory for the firmware");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(wl->fw, fw->data, wl->fw_len);
-
-	ret = 0;
-
-out:
-	release_firmware(fw);
-
-	return ret;
-}
-
-static int wl12xx_fetch_nvs(struct wl12xx *wl)
-{
-	const struct firmware *fw;
-	int ret;
-
-	ret = request_firmware(&fw, wl->chip.nvs_filename, &wl->spi->dev);
-
-	if (ret < 0) {
-		wl12xx_error("could not get nvs file: %d", ret);
-		return ret;
-	}
-
-	if (fw->size % 4) {
-		wl12xx_error("nvs size is not multiple of 32 bits: %zu",
-			     fw->size);
-		ret = -EILSEQ;
-		goto out;
-	}
-
-	wl->nvs_len = fw->size;
-	wl->nvs = kmalloc(wl->nvs_len, GFP_KERNEL);
-
-	if (!wl->nvs) {
-		wl12xx_error("could not allocate memory for the nvs file");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(wl->nvs, fw->data, wl->nvs_len);
-
-	ret = 0;
-
-out:
-	release_firmware(fw);
-
-	return ret;
-}
-
-static void wl12xx_fw_wakeup(struct wl12xx *wl)
-{
-	u32 elp_reg;
-
-	elp_reg = ELPCTRL_WAKE_UP;
-	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
-	elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
-
-	if (!(elp_reg & ELPCTRL_WLAN_READY)) {
-		wl12xx_warning("WLAN not ready");
-	}
-}
-
-static int wl12xx_chip_wakeup(struct wl12xx *wl)
-{
-	int ret = 0;
-
-	wl12xx_power_on(wl);
-	msleep(wl->chip.power_on_sleep);
-	wl12xx_spi_reset(wl);
-	wl12xx_spi_init(wl);
-
-	/* We don't need a real memory partition here, because we only want
-	 * to use the registers at this point. */
-	wl12xx_set_partition(wl,
-			     0x00000000,
-			     0x00000000,
-			     REGISTERS_BASE,
-			     REGISTERS_DOWN_SIZE);
-
-	/* ELP module wake up */
-	wl12xx_fw_wakeup(wl);
-
-	/* whal_FwCtrl_BootSm() */
-
-	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl12xx_reg_read32(wl, CHIP_ID_B);
-
-	/* 1. check if chip id is valid */
-
-	switch (wl->chip.id) {
-	case CHIP_ID_1251_PG12:
-		wl12xx_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG12)",
-			     wl->chip.id);
-
-		wl1251_setup(wl);
-
-		break;
-	case CHIP_ID_1251_PG10:
-	case CHIP_ID_1251_PG11:
-	default:
-		wl12xx_error("unsupported chip id: 0x%x", wl->chip.id);
-		ret = -ENODEV;
-		goto out;
-	}
-
-	if (wl->fw == NULL) {
-		ret = wl12xx_fetch_firmware(wl);
-		if (ret < 0)
-			goto out;
-	}
-
-	/* No NVS from netlink, try to get it from the filesystem */
-	if (wl->nvs == NULL) {
-		ret = wl12xx_fetch_nvs(wl);
-		if (ret < 0)
-			goto out;
-	}
-
-out:
-	return ret;
-}
-
-static void wl12xx_filter_work(struct work_struct *work)
-{
-	struct wl12xx *wl =
-		container_of(work, struct wl12xx, filter_work);
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	if (wl->state == WL12XX_STATE_OFF)
-		goto out;
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	/* FIXME: replace the magic numbers with proper definitions */
-	ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
-	if (ret < 0)
-		goto out_sleep;
-
-out_sleep:
-	wl12xx_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-}
-
-int wl12xx_plt_start(struct wl12xx *wl)
-{
-	int ret;
-
-	wl12xx_notice("power up");
-
-	if (wl->state != WL12XX_STATE_OFF) {
-		wl12xx_error("cannot go into PLT state because not "
-			     "in off state: %d", wl->state);
-		return -EBUSY;
-	}
-
-	wl->state = WL12XX_STATE_PLT;
-
-	ret = wl12xx_chip_wakeup(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl->chip.op_boot(wl);
-	if (ret < 0)
-		return ret;
-
-	wl12xx_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
-
-	ret = wl->chip.op_plt_init(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl12xx_plt_stop(struct wl12xx *wl)
-{
-	wl12xx_notice("power down");
-
-	if (wl->state != WL12XX_STATE_PLT) {
-		wl12xx_error("cannot power down because not in PLT "
-			     "state: %d", wl->state);
-		return -EBUSY;
-	}
-
-	wl12xx_disable_interrupts(wl);
-	wl12xx_power_off(wl);
-
-	wl->state = WL12XX_STATE_OFF;
-
-	return 0;
-}
-
-
-static int wl12xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct wl12xx *wl = hw->priv;
-
-	skb_queue_tail(&wl->tx_queue, skb);
-
-	/*
-	 * The chip specific setup must run before the first TX packet -
-	 * before that, the tx_work will not be initialized!
-	 */
-
-	schedule_work(&wl->tx_work);
-
-	/*
-	 * The workqueue is slow to process the tx_queue and we need stop
-	 * the queue here, otherwise the queue will get too long.
-	 */
-	if (skb_queue_len(&wl->tx_queue) >= WL12XX_TX_QUEUE_MAX_LENGTH) {
-		ieee80211_stop_queues(wl->hw);
-
-		/*
-		 * FIXME: this is racy, the variable is not properly
-		 * protected. Maybe fix this by removing the stupid
-		 * variable altogether and checking the real queue state?
-		 */
-		wl->tx_queue_stopped = true;
-	}
-
-	return NETDEV_TX_OK;
-}
-
-static int wl12xx_op_start(struct ieee80211_hw *hw)
-{
-	struct wl12xx *wl = hw->priv;
-	int ret = 0;
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 start");
-
-	mutex_lock(&wl->mutex);
-
-	if (wl->state != WL12XX_STATE_OFF) {
-		wl12xx_error("cannot start because not in off state: %d",
-			     wl->state);
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ret = wl12xx_chip_wakeup(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl->chip.op_boot(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl->chip.op_hw_init(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl12xx_acx_station_id(wl);
-	if (ret < 0)
-		goto out;
-
-	wl->state = WL12XX_STATE_ON;
-
-	wl12xx_info("firmware booted (%s)", wl->chip.fw_ver);
-
-out:
-	if (ret < 0)
-		wl12xx_power_off(wl);
-
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-
-static void wl12xx_op_stop(struct ieee80211_hw *hw)
-{
-	struct wl12xx *wl = hw->priv;
-
-	wl12xx_info("down");
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 stop");
-
-	mutex_lock(&wl->mutex);
-
-	WARN_ON(wl->state != WL12XX_STATE_ON);
-
-	if (wl->scanning) {
-		mutex_unlock(&wl->mutex);
-		ieee80211_scan_completed(wl->hw, true);
-		mutex_lock(&wl->mutex);
-		wl->scanning = false;
-	}
-
-	wl->state = WL12XX_STATE_OFF;
-
-	wl12xx_disable_interrupts(wl);
-
-	mutex_unlock(&wl->mutex);
-
-	cancel_work_sync(&wl->irq_work);
-	cancel_work_sync(&wl->tx_work);
-	cancel_work_sync(&wl->filter_work);
-
-	mutex_lock(&wl->mutex);
-
-	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl->chip.op_tx_flush(wl);
-	wl12xx_power_off(wl);
-
-	memset(wl->bssid, 0, ETH_ALEN);
-	wl->listen_int = 1;
-	wl->bss_type = MAX_BSS_TYPE;
-
-	wl->data_in_count = 0;
-	wl->rx_counter = 0;
-	wl->rx_handled = 0;
-	wl->rx_current_buffer = 0;
-	wl->rx_last_id = 0;
-	wl->next_tx_complete = 0;
-	wl->elp = false;
-	wl->psm = 0;
-	wl->tx_queue_stopped = false;
-	wl->power_level = WL12XX_DEFAULT_POWER_LEVEL;
-
-	wl12xx_debugfs_reset(wl);
-
-	mutex_unlock(&wl->mutex);
-}
-
-static int wl12xx_op_add_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
-{
-	struct wl12xx *wl = hw->priv;
-	DECLARE_MAC_BUF(mac);
-	int ret = 0;
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
-		     conf->type, print_mac(mac, conf->mac_addr));
-
-	mutex_lock(&wl->mutex);
-
-	switch (conf->type) {
-	case NL80211_IFTYPE_STATION:
-		wl->bss_type = BSS_TYPE_STA_BSS;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		wl->bss_type = BSS_TYPE_IBSS;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (memcmp(wl->mac_addr, conf->mac_addr, ETH_ALEN)) {
-		memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
-		SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
-		ret = wl12xx_acx_station_id(wl);
-		if (ret < 0)
-			goto out;
-	}
-
-out:
-	mutex_unlock(&wl->mutex);
-	return ret;
-}
-
-static void wl12xx_op_remove_interface(struct ieee80211_hw *hw,
-					 struct ieee80211_if_init_conf *conf)
-{
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 remove interface");
-}
-
-static int wl12xx_build_null_data(struct wl12xx *wl)
-{
-	struct wl12xx_null_data_template template;
-
-	if (!is_zero_ether_addr(wl->bssid)) {
-		memcpy(template.header.da, wl->bssid, ETH_ALEN);
-		memcpy(template.header.bssid, wl->bssid, ETH_ALEN);
-	} else {
-		memset(template.header.da, 0xff, ETH_ALEN);
-		memset(template.header.bssid, 0xff, ETH_ALEN);
-	}
-
-	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
-	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
-						IEEE80211_STYPE_NULLFUNC);
-
-	return wl12xx_cmd_template_set(wl, CMD_NULL_DATA, &template,
-				       sizeof(template));
-
-}
-
-static int wl12xx_build_ps_poll(struct wl12xx *wl, u16 aid)
-{
-	struct wl12xx_ps_poll_template template;
-
-	memcpy(template.bssid, wl->bssid, ETH_ALEN);
-	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
-	template.aid = aid;
-	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
-
-	return wl12xx_cmd_template_set(wl, CMD_PS_POLL, &template,
-				       sizeof(template));
-
-}
-
-static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
-{
-	struct wl12xx *wl = hw->priv;
-	struct ieee80211_conf *conf = &hw->conf;
-	int channel, ret = 0;
-
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
-		     channel,
-		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
-		     conf->power_level);
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	if (channel != wl->channel) {
-		/* FIXME: use beacon interval provided by mac80211 */
-		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
-		if (ret < 0)
-			goto out_sleep;
-
-		wl->channel = channel;
-	}
-
-	ret = wl12xx_build_null_data(wl);
-	if (ret < 0)
-		goto out_sleep;
-
-	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
-		wl12xx_info("psm enabled");
-
-		wl->psm_requested = true;
-
-		/*
-		 * We enter PSM only if we're already associated.
-		 * If we're not, we'll enter it when joining an SSID,
-		 * through the bss_info_changed() hook.
-		 */
-		ret = wl12xx_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
-	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   wl->psm_requested) {
-		wl12xx_info("psm disabled");
-
-		wl->psm_requested = false;
-
-		if (wl->psm)
-			ret = wl12xx_ps_set_mode(wl, STATION_ACTIVE_MODE);
-	}
-
-	if (conf->power_level != wl->power_level) {
-		ret = wl12xx_acx_tx_power(wl, conf->power_level);
-		if (ret < 0)
-			goto out;
-
-		wl->power_level = conf->power_level;
-	}
-
-out_sleep:
-	wl12xx_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-
-#define WL12XX_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
-				  FIF_ALLMULTI | \
-				  FIF_FCSFAIL | \
-				  FIF_BCN_PRBRESP_PROMISC | \
-				  FIF_CONTROL | \
-				  FIF_OTHER_BSS)
-
-static void wl12xx_op_configure_filter(struct ieee80211_hw *hw,
-				       unsigned int changed,
-				       unsigned int *total,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
-{
-	struct wl12xx *wl = hw->priv;
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 configure filter");
-
-	*total &= WL12XX_SUPPORTED_FILTERS;
-	changed &= WL12XX_SUPPORTED_FILTERS;
-
-	if (changed == 0)
-		/* no filters which we support changed */
-		return;
-
-	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
-
-	wl->rx_config = WL12XX_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL12XX_DEFAULT_RX_FILTER;
-
-	if (*total & FIF_PROMISC_IN_BSS) {
-		wl->rx_config |= CFG_BSSID_FILTER_EN;
-		wl->rx_config |= CFG_RX_ALL_GOOD;
-	}
-	if (*total & FIF_ALLMULTI)
-		/*
-		 * CFG_MC_FILTER_EN in rx_config needs to be 0 to receive
-		 * all multicast frames
-		 */
-		wl->rx_config &= ~CFG_MC_FILTER_EN;
-	if (*total & FIF_FCSFAIL)
-		wl->rx_filter |= CFG_RX_FCS_ERROR;
-	if (*total & FIF_BCN_PRBRESP_PROMISC) {
-		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
-		wl->rx_config &= ~CFG_SSID_FILTER_EN;
-	}
-	if (*total & FIF_CONTROL)
-		wl->rx_filter |= CFG_RX_CTL_EN;
-	if (*total & FIF_OTHER_BSS)
-		wl->rx_filter &= ~CFG_BSSID_FILTER_EN;
-
-	/*
-	 * FIXME: workqueues need to be properly cancelled on stop(), for
-	 * now let's just disable changing the filter settings. They will
-	 * be updated any on config().
-	 */
-	/* schedule_work(&wl->filter_work); */
-}
-
-/* HW encryption */
-static int wl12xx_set_key_type(struct wl12xx *wl,
-			       struct wl12xx_cmd_set_keys *key,
-			       enum set_key_cmd cmd,
-			       struct ieee80211_key_conf *mac80211_key,
-			       const u8 *addr)
-{
-	switch (mac80211_key->alg) {
-	case ALG_WEP:
-		if (is_broadcast_ether_addr(addr))
-			key->key_type = KEY_WEP_DEFAULT;
-		else
-			key->key_type = KEY_WEP_ADDR;
-
-		mac80211_key->hw_key_idx = mac80211_key->keyidx;
-		break;
-	case ALG_TKIP:
-		if (is_broadcast_ether_addr(addr))
-			key->key_type = KEY_TKIP_MIC_GROUP;
-		else
-			key->key_type = KEY_TKIP_MIC_PAIRWISE;
-
-		mac80211_key->hw_key_idx = mac80211_key->keyidx;
-		break;
-	case ALG_CCMP:
-		if (is_broadcast_ether_addr(addr))
-			key->key_type = KEY_AES_GROUP;
-		else
-			key->key_type = KEY_AES_PAIRWISE;
-		mac80211_key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		break;
-	default:
-		wl12xx_error("Unknown key algo 0x%x", mac80211_key->alg);
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_sta *sta,
-			     struct ieee80211_key_conf *key)
-{
-	struct wl12xx *wl = hw->priv;
-	struct wl12xx_cmd_set_keys *wl_cmd;
-	const u8 *addr;
-	int ret;
-
-	static const u8 bcast_addr[ETH_ALEN] =
-		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 set key");
-
-	wl_cmd = kzalloc(sizeof(*wl_cmd), GFP_KERNEL);
-	if (!wl_cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	addr = sta ? sta->addr : bcast_addr;
-
-	wl12xx_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
-	wl12xx_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
-	wl12xx_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
-		     key->alg, key->keyidx, key->keylen, key->flags);
-	wl12xx_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
-
-	if (is_zero_ether_addr(addr)) {
-		/* We dont support TX only encryption */
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out_unlock;
-
-	switch (cmd) {
-	case SET_KEY:
-		wl_cmd->key_action = KEY_ADD_OR_REPLACE;
-		break;
-	case DISABLE_KEY:
-		wl_cmd->key_action = KEY_REMOVE;
-		break;
-	default:
-		wl12xx_error("Unsupported key cmd 0x%x", cmd);
-		break;
-	}
-
-	ret = wl12xx_set_key_type(wl, wl_cmd, cmd, key, addr);
-	if (ret < 0) {
-		wl12xx_error("Set KEY type failed");
-		goto out_sleep;
-	}
-
-	if (wl_cmd->key_type != KEY_WEP_DEFAULT)
-		memcpy(wl_cmd->addr, addr, ETH_ALEN);
-
-	if ((wl_cmd->key_type == KEY_TKIP_MIC_GROUP) ||
-	    (wl_cmd->key_type == KEY_TKIP_MIC_PAIRWISE)) {
-		/*
-		 * We get the key in the following form:
-		 * TKIP (16 bytes) - TX MIC (8 bytes) - RX MIC (8 bytes)
-		 * but the target is expecting:
-		 * TKIP - RX MIC - TX MIC
-		 */
-		memcpy(wl_cmd->key, key->key, 16);
-		memcpy(wl_cmd->key + 16, key->key + 24, 8);
-		memcpy(wl_cmd->key + 24, key->key + 16, 8);
-
-	} else {
-		memcpy(wl_cmd->key, key->key, key->keylen);
-	}
-	wl_cmd->key_size = key->keylen;
-
-	wl_cmd->id = key->keyidx;
-	wl_cmd->ssid_profile = 0;
-
-	wl12xx_dump(DEBUG_CRYPT, "TARGET KEY: ", wl_cmd, sizeof(*wl_cmd));
-
-	ret = wl12xx_cmd_send(wl, CMD_SET_KEYS, wl_cmd, sizeof(*wl_cmd));
-	if (ret < 0) {
-		wl12xx_warning("could not set keys");
-		goto out_sleep;
-	}
-
-out_sleep:
-	wl12xx_ps_elp_sleep(wl);
-
-out_unlock:
-	mutex_unlock(&wl->mutex);
-
-out:
-	kfree(wl_cmd);
-
-	return ret;
-}
-
-static int wl12xx_build_basic_rates(char *rates)
-{
-	u8 index = 0;
-
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
-
-	return index;
-}
-
-static int wl12xx_build_extended_rates(char *rates)
-{
-	u8 index = 0;
-
-	rates[index++] = IEEE80211_OFDM_RATE_6MB;
-	rates[index++] = IEEE80211_OFDM_RATE_9MB;
-	rates[index++] = IEEE80211_OFDM_RATE_12MB;
-	rates[index++] = IEEE80211_OFDM_RATE_18MB;
-	rates[index++] = IEEE80211_OFDM_RATE_24MB;
-	rates[index++] = IEEE80211_OFDM_RATE_36MB;
-	rates[index++] = IEEE80211_OFDM_RATE_48MB;
-	rates[index++] = IEEE80211_OFDM_RATE_54MB;
-
-	return index;
-}
-
-
-static int wl12xx_build_probe_req(struct wl12xx *wl, u8 *ssid, size_t ssid_len)
-{
-	struct wl12xx_probe_req_template template;
-	struct wl12xx_ie_rates *rates;
-	char *ptr;
-	u16 size;
-
-	ptr = (char *)&template;
-	size = sizeof(struct ieee80211_header);
-
-	memset(template.header.da, 0xff, ETH_ALEN);
-	memset(template.header.bssid, 0xff, ETH_ALEN);
-	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
-	template.header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-
-	/* IEs */
-	/* SSID */
-	template.ssid.header.id = WLAN_EID_SSID;
-	template.ssid.header.len = ssid_len;
-	if (ssid_len && ssid)
-		memcpy(template.ssid.ssid, ssid, ssid_len);
-	size += sizeof(struct wl12xx_ie_header) + ssid_len;
-	ptr += size;
-
-	/* Basic Rates */
-	rates = (struct wl12xx_ie_rates *)ptr;
-	rates->header.id = WLAN_EID_SUPP_RATES;
-	rates->header.len = wl12xx_build_basic_rates(rates->rates);
-	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
-	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
-
-	/* Extended rates */
-	rates = (struct wl12xx_ie_rates *)ptr;
-	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
-	rates->header.len = wl12xx_build_extended_rates(rates->rates);
-	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
-
-	wl12xx_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
-
-	return wl12xx_cmd_template_set(wl, CMD_PROBE_REQ, &template,
-				      size);
-}
-
-static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
-			  u8 active_scan, u8 high_prio, u8 num_channels,
-			  u8 probe_requests)
-{
-	struct wl12xx_cmd_trigger_scan_to *trigger = NULL;
-	struct cmd_scan *params = NULL;
-	int i, ret;
-	u16 scan_options = 0;
-
-	if (wl->scanning)
-		return -EINVAL;
-
-	params = kzalloc(sizeof(*params), GFP_KERNEL);
-	if (!params)
-		return -ENOMEM;
-
-	params->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
-	params->params.rx_filter_options =
-		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
-
-	/* High priority scan */
-	if (!active_scan)
-		scan_options |= SCAN_PASSIVE;
-	if (high_prio)
-		scan_options |= SCAN_PRIORITY_HIGH;
-	params->params.scan_options = scan_options;
-
-	params->params.num_channels = num_channels;
-	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */
-	params->params.tid_trigger = 0;
-
-	for (i = 0; i < num_channels; i++) {
-		params->channels[i].min_duration = cpu_to_le32(30000);
-		params->channels[i].max_duration = cpu_to_le32(60000);
-		memset(&params->channels[i].bssid_lsb, 0xff, 4);
-		memset(&params->channels[i].bssid_msb, 0xff, 2);
-		params->channels[i].early_termination = 0;
-		params->channels[i].tx_power_att = 0;
-		params->channels[i].channel = i + 1;
-		memset(params->channels[i].pad, 0, 3);
-	}
-
-	for (i = num_channels; i < SCAN_MAX_NUM_OF_CHANNELS; i++)
-		memset(&params->channels[i], 0,
-		       sizeof(struct basic_scan_channel_parameters));
-
-	if (len && ssid) {
-		params->params.ssid_len = len;
-		memcpy(params->params.ssid, ssid, len);
-	} else {
-		params->params.ssid_len = 0;
-		memset(params->params.ssid, 0, 32);
-	}
-
-	ret = wl12xx_build_probe_req(wl, ssid, len);
-	if (ret < 0) {
-		wl12xx_error("PROBE request template failed");
-		goto out;
-	}
-
-	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
-	if (!trigger)
-		goto out;
-
-	trigger->timeout = 0;
-
-	ret = wl12xx_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
-			      sizeof(*trigger));
-	if (ret < 0) {
-		wl12xx_error("trigger scan to failed for hw scan");
-		goto out;
-	}
-
-	wl12xx_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
-
-	wl->scanning = true;
-
-	ret = wl12xx_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
-	if (ret < 0)
-		wl12xx_error("SCAN failed");
-
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
-
-	if (params->header.status != CMD_STATUS_SUCCESS) {
-		wl12xx_error("TEST command answer error: %d",
-			     params->header.status);
-		wl->scanning = false;
-		ret = -EIO;
-		goto out;
-	}
-
-out:
-	kfree(params);
-	return ret;
-
-}
-
-static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
-			     struct cfg80211_scan_request *req)
-{
-	struct wl12xx *wl = hw->priv;
-	int ret;
-	u8 *ssid = NULL;
-	size_t ssid_len = 0;
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 hw scan");
-
-	if (req->n_ssids) {
-		ssid = req->ssids[0].ssid;
-		ssid_len = req->ssids[0].ssid_len;
-	}
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
-
-	wl12xx_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-
-static int wl12xx_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct wl12xx *wl = hw->priv;
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl12xx_acx_rts_threshold(wl, (u16) value);
-	if (ret < 0)
-		wl12xx_warning("wl12xx_op_set_rts_threshold failed: %d", ret);
-
-	wl12xx_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-
-static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       struct ieee80211_bss_conf *bss_conf,
-				       u32 changed)
-{
-	enum wl12xx_cmd_ps_mode mode;
-	struct wl12xx *wl = hw->priv;
-	struct sk_buff *beacon;
-	int ret;
-
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 bss info changed");
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl12xx_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	if (changed & BSS_CHANGED_ASSOC) {
-		if (bss_conf->assoc) {
-			wl->aid = bss_conf->aid;
-
-			ret = wl12xx_build_ps_poll(wl, wl->aid);
-			if (ret < 0)
-				goto out_sleep;
-
-			ret = wl12xx_acx_aid(wl, wl->aid);
-			if (ret < 0)
-				goto out_sleep;
-
-			/* If we want to go in PSM but we're not there yet */
-			if (wl->psm_requested && !wl->psm) {
-				mode = STATION_POWER_SAVE_MODE;
-				ret = wl12xx_ps_set_mode(wl, mode);
-				if (ret < 0)
-					goto out_sleep;
-			}
-		}
-	}
-	if (changed & BSS_CHANGED_ERP_SLOT) {
-		if (bss_conf->use_short_slot)
-			ret = wl12xx_acx_slot(wl, SLOT_TIME_SHORT);
-		else
-			ret = wl12xx_acx_slot(wl, SLOT_TIME_LONG);
-		if (ret < 0) {
-			wl12xx_warning("Set slot time failed %d", ret);
-			goto out_sleep;
-		}
-	}
-
-	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		if (bss_conf->use_short_preamble)
-			wl12xx_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
-		else
-			wl12xx_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
-	}
-
-	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		if (bss_conf->use_cts_prot)
-			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_ENABLE);
-		else
-			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_DISABLE);
-		if (ret < 0) {
-			wl12xx_warning("Set ctsprotect failed %d", ret);
-			goto out_sleep;
-		}
-	}
-
-	if (changed & BSS_CHANGED_BSSID) {
-		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
-
-		ret = wl12xx_build_null_data(wl);
-		if (ret < 0)
-			goto out;
-
-		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl->chip.op_cmd_join(wl, wl->bss_type, 5, 100, 1);
-			if (ret < 0)
-				goto out;
-		}
-	}
-
-	if (changed & BSS_CHANGED_BEACON) {
-		beacon = ieee80211_beacon_get(hw, vif);
-		ret = wl12xx_cmd_template_set(wl, CMD_BEACON, beacon->data,
-					      beacon->len);
-
-		if (ret < 0) {
-			dev_kfree_skb(beacon);
-			goto out;
-		}
-
-		ret = wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
-					      beacon->len);
-
-		dev_kfree_skb(beacon);
-
-		if (ret < 0)
-			goto out;
-
-		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
-
-		if (ret < 0)
-			goto out;
-	}
-
-out_sleep:
-	wl12xx_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-}
-
-
-/* can't be const, mac80211 writes to this */
-static struct ieee80211_rate wl12xx_rates[] = {
-	{ .bitrate = 10,
-	  .hw_value = 0x1,
-	  .hw_value_short = 0x1, },
-	{ .bitrate = 20,
-	  .hw_value = 0x2,
-	  .hw_value_short = 0x2,
-	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
-	{ .bitrate = 55,
-	  .hw_value = 0x4,
-	  .hw_value_short = 0x4,
-	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
-	{ .bitrate = 110,
-	  .hw_value = 0x20,
-	  .hw_value_short = 0x20,
-	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
-	{ .bitrate = 60,
-	  .hw_value = 0x8,
-	  .hw_value_short = 0x8, },
-	{ .bitrate = 90,
-	  .hw_value = 0x10,
-	  .hw_value_short = 0x10, },
-	{ .bitrate = 120,
-	  .hw_value = 0x40,
-	  .hw_value_short = 0x40, },
-	{ .bitrate = 180,
-	  .hw_value = 0x80,
-	  .hw_value_short = 0x80, },
-	{ .bitrate = 240,
-	  .hw_value = 0x200,
-	  .hw_value_short = 0x200, },
-	{ .bitrate = 360,
-	 .hw_value = 0x400,
-	 .hw_value_short = 0x400, },
-	{ .bitrate = 480,
-	  .hw_value = 0x800,
-	  .hw_value_short = 0x800, },
-	{ .bitrate = 540,
-	  .hw_value = 0x1000,
-	  .hw_value_short = 0x1000, },
-};
-
-/* can't be const, mac80211 writes to this */
-static struct ieee80211_channel wl12xx_channels[] = {
-	{ .hw_value = 1, .center_freq = 2412},
-	{ .hw_value = 2, .center_freq = 2417},
-	{ .hw_value = 3, .center_freq = 2422},
-	{ .hw_value = 4, .center_freq = 2427},
-	{ .hw_value = 5, .center_freq = 2432},
-	{ .hw_value = 6, .center_freq = 2437},
-	{ .hw_value = 7, .center_freq = 2442},
-	{ .hw_value = 8, .center_freq = 2447},
-	{ .hw_value = 9, .center_freq = 2452},
-	{ .hw_value = 10, .center_freq = 2457},
-	{ .hw_value = 11, .center_freq = 2462},
-	{ .hw_value = 12, .center_freq = 2467},
-	{ .hw_value = 13, .center_freq = 2472},
-};
-
-/* can't be const, mac80211 writes to this */
-static struct ieee80211_supported_band wl12xx_band_2ghz = {
-	.channels = wl12xx_channels,
-	.n_channels = ARRAY_SIZE(wl12xx_channels),
-	.bitrates = wl12xx_rates,
-	.n_bitrates = ARRAY_SIZE(wl12xx_rates),
-};
-
-static const struct ieee80211_ops wl12xx_ops = {
-	.start = wl12xx_op_start,
-	.stop = wl12xx_op_stop,
-	.add_interface = wl12xx_op_add_interface,
-	.remove_interface = wl12xx_op_remove_interface,
-	.config = wl12xx_op_config,
-	.configure_filter = wl12xx_op_configure_filter,
-	.tx = wl12xx_op_tx,
-	.set_key = wl12xx_op_set_key,
-	.hw_scan = wl12xx_op_hw_scan,
-	.bss_info_changed = wl12xx_op_bss_info_changed,
-	.set_rts_threshold = wl12xx_op_set_rts_threshold,
-};
-
-static int wl12xx_register_hw(struct wl12xx *wl)
-{
-	int ret;
-
-	if (wl->mac80211_registered)
-		return 0;
-
-	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
-
-	ret = ieee80211_register_hw(wl->hw);
-	if (ret < 0) {
-		wl12xx_error("unable to register mac80211 hw: %d", ret);
-		return ret;
-	}
-
-	wl->mac80211_registered = true;
-
-	wl12xx_notice("loaded");
-
-	return 0;
-}
-
-static int wl12xx_init_ieee80211(struct wl12xx *wl)
-{
-	/* The tx descriptor buffer and the TKIP space */
-	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
-		+ WL1251_TKIP_IV_SPACE;
-
-	/* unit us */
-	/* FIXME: find a proper value */
-	wl->hw->channel_change_time = 10000;
-
-	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM;
-
-	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-	wl->hw->wiphy->max_scan_ssids = 1;
-	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
-
-	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
-
-	return 0;
-}
-
-#define WL12XX_DEFAULT_CHANNEL 1
-static int __devinit wl12xx_probe(struct spi_device *spi)
-{
-	struct wl12xx_platform_data *pdata;
-	struct ieee80211_hw *hw;
-	struct wl12xx *wl;
-	int ret, i;
-	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
-
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		wl12xx_error("no platform data");
-		return -ENODEV;
-	}
-
-	hw = ieee80211_alloc_hw(sizeof(*wl), &wl12xx_ops);
-	if (!hw) {
-		wl12xx_error("could not alloc ieee80211_hw");
-		return -ENOMEM;
-	}
-
-	wl = hw->priv;
-	memset(wl, 0, sizeof(*wl));
-
-	wl->hw = hw;
-	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
-
-	wl->data_in_count = 0;
-
-	skb_queue_head_init(&wl->tx_queue);
-
-	INIT_WORK(&wl->filter_work, wl12xx_filter_work);
-	wl->channel = WL12XX_DEFAULT_CHANNEL;
-	wl->scanning = false;
-	wl->default_key = 0;
-	wl->listen_int = 1;
-	wl->rx_counter = 0;
-	wl->rx_handled = 0;
-	wl->rx_current_buffer = 0;
-	wl->rx_last_id = 0;
-	wl->rx_config = WL12XX_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL12XX_DEFAULT_RX_FILTER;
-	wl->elp = false;
-	wl->psm = 0;
-	wl->psm_requested = false;
-	wl->tx_queue_stopped = false;
-	wl->power_level = WL12XX_DEFAULT_POWER_LEVEL;
-
-	/* We use the default power on sleep time until we know which chip
-	 * we're using */
-	wl->chip.power_on_sleep = WL12XX_DEFAULT_POWER_ON_SLEEP;
-
-	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
-		wl->tx_frames[i] = NULL;
-
-	wl->next_tx_complete = 0;
-
-	/*
-	 * In case our MAC address is not correctly set,
-	 * we use a random but Nokia MAC.
-	 */
-	memcpy(wl->mac_addr, nokia_oui, 3);
-	get_random_bytes(wl->mac_addr + 3, 3);
-
-	wl->state = WL12XX_STATE_OFF;
-	mutex_init(&wl->mutex);
-
-	wl->tx_mgmt_frm_rate = DEFAULT_HW_GEN_TX_RATE;
-	wl->tx_mgmt_frm_mod = DEFAULT_HW_GEN_MODULATION_TYPE;
-
-	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
-	if (!wl->rx_descriptor) {
-		wl12xx_error("could not allocate memory for rx descriptor");
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	/* This is the only SPI value that we need to set here, the rest
-	 * comes from the board-peripherals file */
-	spi->bits_per_word = 32;
-
-	ret = spi_setup(spi);
-	if (ret < 0) {
-		wl12xx_error("spi_setup failed");
-		goto out_free;
-	}
-
-	wl->set_power = pdata->set_power;
-	if (!wl->set_power) {
-		wl12xx_error("set power function missing in platform data");
-		ret = -ENODEV;
-		goto out_free;
-	}
-
-	wl->irq = spi->irq;
-	if (wl->irq < 0) {
-		wl12xx_error("irq missing in platform data");
-		ret = -ENODEV;
-		goto out_free;
-	}
-
-	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl12xx_error("request_irq() failed: %d", ret);
-		goto out_free;
-	}
-
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
-	disable_irq(wl->irq);
-
-	ret = wl12xx_init_ieee80211(wl);
-	if (ret)
-		goto out_irq;
-
-	ret = wl12xx_register_hw(wl);
-	if (ret)
-		goto out_irq;
-
-	wl12xx_debugfs_init(wl);
-
-	wl12xx_notice("initialized");
-
-	return 0;
-
- out_irq:
-	free_irq(wl->irq, wl);
-
- out_free:
-	kfree(wl->rx_descriptor);
-	wl->rx_descriptor = NULL;
-
-	ieee80211_free_hw(hw);
-
-	return ret;
-}
-
-static int __devexit wl12xx_remove(struct spi_device *spi)
-{
-	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
-
-	ieee80211_unregister_hw(wl->hw);
-
-	wl12xx_debugfs_exit(wl);
-
-	free_irq(wl->irq, wl);
-	kfree(wl->target_mem_map);
-	kfree(wl->data_path);
-	kfree(wl->fw);
-	wl->fw = NULL;
-	kfree(wl->nvs);
-	wl->nvs = NULL;
-
-	kfree(wl->rx_descriptor);
-	wl->rx_descriptor = NULL;
-
-	ieee80211_free_hw(wl->hw);
-
-	return 0;
-}
-
-
-static struct spi_driver wl12xx_spi_driver = {
-	.driver = {
-		.name		= "wl12xx",
-		.bus		= &spi_bus_type,
-		.owner		= THIS_MODULE,
-	},
-
-	.probe		= wl12xx_probe,
-	.remove		= __devexit_p(wl12xx_remove),
-};
-
-static int __init wl12xx_init(void)
-{
-	int ret;
-
-	ret = spi_register_driver(&wl12xx_spi_driver);
-	if (ret < 0) {
-		wl12xx_error("failed to register spi driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
-}
-
-static void __exit wl12xx_exit(void)
-{
-	spi_unregister_driver(&wl12xx_spi_driver);
-
-	wl12xx_notice("unloaded");
-}
-
-module_init(wl12xx_init);
-module_exit(wl12xx_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
-		"Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
deleted file mode 100644
index f28f194..0000000
--- a/drivers/net/wireless/wl12xx/ps.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include "reg.h"
-#include "ps.h"
-#include "spi.h"
-
-#define WL12XX_WAKEUP_TIMEOUT 2000
-
-/* Routines to toggle sleep mode while in ELP */
-void wl12xx_ps_elp_sleep(struct wl12xx *wl)
-{
-	if (wl->elp || !wl->psm)
-		return;
-
-	wl12xx_debug(DEBUG_PSM, "chip to elp");
-
-	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
-
-	wl->elp = true;
-}
-
-int wl12xx_ps_elp_wakeup(struct wl12xx *wl)
-{
-	unsigned long timeout;
-	u32 elp_reg;
-
-	if (!wl->elp)
-		return 0;
-
-	wl12xx_debug(DEBUG_PSM, "waking up chip from elp");
-
-	timeout = jiffies + msecs_to_jiffies(WL12XX_WAKEUP_TIMEOUT);
-
-	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
-
-	elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
-
-	/*
-	 * FIXME: we should wait for irq from chip but, as a temporary
-	 * solution to simplify locking, let's poll instead
-	 */
-	while (!(elp_reg & ELPCTRL_WLAN_READY)) {
-		if (time_after(jiffies, timeout)) {
-			wl12xx_error("elp wakeup timeout");
-			return -ETIMEDOUT;
-		}
-		msleep(1);
-		elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
-	}
-
-	wl12xx_debug(DEBUG_PSM, "wakeup time: %u ms",
-		     jiffies_to_msecs(jiffies) -
-		     (jiffies_to_msecs(timeout) - WL12XX_WAKEUP_TIMEOUT));
-
-	wl->elp = false;
-
-	return 0;
-}
-
-static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
-{
-	int ret;
-
-	if (enable) {
-		wl12xx_debug(DEBUG_PSM, "sleep auth psm/elp");
-
-		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_ELP);
-		if (ret < 0)
-			return ret;
-
-		wl12xx_ps_elp_sleep(wl);
-	} else {
-		wl12xx_debug(DEBUG_PSM, "sleep auth cam");
-
-		/*
-		 * When the target is in ELP, we can only
-		 * access the ELP control register. Thus,
-		 * we have to wake the target up before
-		 * changing the power authorization.
-		 */
-
-		wl12xx_ps_elp_wakeup(wl);
-
-		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_CAM);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
-int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode)
-{
-	int ret;
-
-	switch (mode) {
-	case STATION_POWER_SAVE_MODE:
-		wl12xx_debug(DEBUG_PSM, "entering psm");
-		ret = wl12xx_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
-		if (ret < 0)
-			return ret;
-
-		ret = wl12xx_ps_set_elp(wl, true);
-		if (ret < 0)
-			return ret;
-
-		wl->psm = 1;
-		break;
-	case STATION_ACTIVE_MODE:
-	default:
-		wl12xx_debug(DEBUG_PSM, "leaving psm");
-		ret = wl12xx_ps_set_elp(wl, false);
-		if (ret < 0)
-			return ret;
-
-		ret = wl12xx_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
-		if (ret < 0)
-			return ret;
-
-		wl->psm = 0;
-		break;
-	}
-
-	return ret;
-}
-
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
deleted file mode 100644
index ad61b4a..0000000
--- a/drivers/net/wireless/wl12xx/ps.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef __WL12XX_PS_H__
-#define __WL12XX_PS_H__
-
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include "wl12xx.h"
-#include "acx.h"
-
-int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode);
-void wl12xx_ps_elp_sleep(struct wl12xx *wl);
-int wl12xx_ps_elp_wakeup(struct wl12xx *wl);
-
-
-#endif /* __WL12XX_PS_H__ */
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
deleted file mode 100644
index 7ac26ef..0000000
--- a/drivers/net/wireless/wl12xx/rx.c
+++ /dev/null
@@ -1,194 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/skbuff.h>
-#include <net/mac80211.h>
-
-#include "wl12xx.h"
-#include "reg.h"
-#include "spi.h"
-#include "rx.h"
-
-static void wl12xx_rx_header(struct wl12xx *wl,
-			     struct wl12xx_rx_descriptor *desc)
-{
-	u32 rx_packet_ring_addr;
-
-	rx_packet_ring_addr = wl->data_path->rx_packet_ring_addr;
-	if (wl->rx_current_buffer)
-		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
-
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
-}
-
-static void wl12xx_rx_status(struct wl12xx *wl,
-			     struct wl12xx_rx_descriptor *desc,
-			     struct ieee80211_rx_status *status,
-			     u8 beacon)
-{
-	u64 mactime;
-	int ret;
-
-	memset(status, 0, sizeof(struct ieee80211_rx_status));
-
-	status->band = IEEE80211_BAND_2GHZ;
-	status->mactime = desc->timestamp;
-
-	/*
-	 * The rx status timestamp is a 32 bits value while the TSF is a
-	 * 64 bits one.
-	 * For IBSS merging, TSF is mandatory, so we have to get it
-	 * somehow, so we ask for ACX_TSF_INFO.
-	 * That could be moved to the get_tsf() hook, but unfortunately,
-	 * this one must be atomic, while our SPI routines can sleep.
-	 */
-	if ((wl->bss_type == BSS_TYPE_IBSS) && beacon) {
-		ret = wl12xx_acx_tsf_info(wl, &mactime);
-		if (ret == 0)
-			status->mactime = mactime;
-	}
-
-	status->signal = desc->rssi;
-	status->qual = (desc->rssi - WL12XX_RX_MIN_RSSI) * 100 /
-		(WL12XX_RX_MAX_RSSI - WL12XX_RX_MIN_RSSI);
-	status->qual = min(status->qual, 100);
-	status->qual = max(status->qual, 0);
-
-	/*
-	 * FIXME: guessing that snr needs to be divided by two, otherwise
-	 * the values don't make any sense
-	 */
-	status->noise = desc->rssi - desc->snr / 2;
-
-	status->freq = ieee80211_channel_to_frequency(desc->channel);
-
-	status->flag |= RX_FLAG_TSFT;
-
-	if (desc->flags & RX_DESC_ENCRYPTION_MASK) {
-		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
-
-		if (likely(!(desc->flags & RX_DESC_DECRYPT_FAIL)))
-			status->flag |= RX_FLAG_DECRYPTED;
-
-		if (unlikely(desc->flags & RX_DESC_MIC_FAIL))
-			status->flag |= RX_FLAG_MMIC_ERROR;
-	}
-
-	if (unlikely(!(desc->flags & RX_DESC_VALID_FCS)))
-		status->flag |= RX_FLAG_FAILED_FCS_CRC;
-
-
-	/* FIXME: set status->rate_idx */
-}
-
-static void wl12xx_rx_body(struct wl12xx *wl,
-			   struct wl12xx_rx_descriptor *desc)
-{
-	struct sk_buff *skb;
-	struct ieee80211_rx_status status;
-	u8 *rx_buffer, beacon = 0;
-	u16 length, *fc;
-	u32 curr_id, last_id_inc, rx_packet_ring_addr;
-
-	length = WL12XX_RX_ALIGN(desc->length  - PLCP_HEADER_LENGTH);
-	curr_id = (desc->flags & RX_DESC_SEQNUM_MASK) >> RX_DESC_PACKETID_SHIFT;
-	last_id_inc = (wl->rx_last_id + 1) % (RX_MAX_PACKET_ID + 1);
-
-	if (last_id_inc != curr_id) {
-		wl12xx_warning("curr ID:%d, last ID inc:%d",
-			       curr_id, last_id_inc);
-		wl->rx_last_id = curr_id;
-	} else {
-		wl->rx_last_id = last_id_inc;
-	}
-
-	rx_packet_ring_addr = wl->data_path->rx_packet_ring_addr +
-		sizeof(struct wl12xx_rx_descriptor) + 20;
-	if (wl->rx_current_buffer)
-		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
-
-	skb = dev_alloc_skb(length);
-	if (!skb) {
-		wl12xx_error("Couldn't allocate RX frame");
-		return;
-	}
-
-	rx_buffer = skb_put(skb, length);
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
-
-	/* The actual lenght doesn't include the target's alignment */
-	skb->len = desc->length  - PLCP_HEADER_LENGTH;
-
-	fc = (u16 *)skb->data;
-
-	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
-		beacon = 1;
-
-	wl12xx_rx_status(wl, desc, &status, beacon);
-
-	wl12xx_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
-		     beacon ? "beacon" : "");
-
-	ieee80211_rx(wl->hw, skb, &status);
-}
-
-static void wl12xx_rx_ack(struct wl12xx *wl)
-{
-	u32 data, addr;
-
-	if (wl->rx_current_buffer) {
-		addr = ACX_REG_INTERRUPT_TRIG_H;
-		data = INTR_TRIG_RX_PROC1;
-	} else {
-		addr = ACX_REG_INTERRUPT_TRIG;
-		data = INTR_TRIG_RX_PROC0;
-	}
-
-	wl12xx_reg_write32(wl, addr, data);
-
-	/* Toggle buffer ring */
-	wl->rx_current_buffer = !wl->rx_current_buffer;
-}
-
-
-void wl12xx_rx(struct wl12xx *wl)
-{
-	struct wl12xx_rx_descriptor *rx_desc;
-
-	if (wl->state != WL12XX_STATE_ON)
-		return;
-
-	rx_desc = wl->rx_descriptor;
-
-	/* We first read the frame's header */
-	wl12xx_rx_header(wl, rx_desc);
-
-	/* Now we can read the body */
-	wl12xx_rx_body(wl, rx_desc);
-
-	/* Finally, we need to ACK the RX */
-	wl12xx_rx_ack(wl);
-
-	return;
-}
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
deleted file mode 100644
index 8a23fde..0000000
--- a/drivers/net/wireless/wl12xx/rx.h
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_RX_H__
-#define __WL12XX_RX_H__
-
-#include <linux/bitops.h>
-
-/*
- * RX PATH
- *
- * The Rx path uses a double buffer and an rx_contro structure, each located
- * at a fixed address in the device memory. The host keeps track of which
- * buffer is available and alternates between them on a per packet basis.
- * The size of each of the two buffers is large enough to hold the longest
- * 802.3 packet.
- * The RX path goes like that:
- * 1) The target generates an interrupt each time a new packet is received.
- *   There are 2 RX interrupts, one for each buffer.
- * 2) The host reads the received packet from one of the double buffers.
- * 3) The host triggers a target interrupt.
- * 4) The target prepares the next RX packet.
- */
-
-#define WL12XX_RX_MAX_RSSI -30
-#define WL12XX_RX_MIN_RSSI -95
-
-#define WL12XX_RX_ALIGN_TO 4
-#define WL12XX_RX_ALIGN(len) (((len) + WL12XX_RX_ALIGN_TO - 1) & \
-			     ~(WL12XX_RX_ALIGN_TO - 1))
-
-#define SHORT_PREAMBLE_BIT   BIT(0)
-#define OFDM_RATE_BIT        BIT(6)
-#define PBCC_RATE_BIT        BIT(7)
-
-#define PLCP_HEADER_LENGTH 8
-#define RX_DESC_PACKETID_SHIFT 11
-#define RX_MAX_PACKET_ID 3
-
-#define RX_DESC_VALID_FCS         0x0001
-#define RX_DESC_MATCH_RXADDR1     0x0002
-#define RX_DESC_MCAST             0x0004
-#define RX_DESC_STAINTIM          0x0008
-#define RX_DESC_VIRTUAL_BM        0x0010
-#define RX_DESC_BCAST             0x0020
-#define RX_DESC_MATCH_SSID        0x0040
-#define RX_DESC_MATCH_BSSID       0x0080
-#define RX_DESC_ENCRYPTION_MASK   0x0300
-#define RX_DESC_MEASURMENT        0x0400
-#define RX_DESC_SEQNUM_MASK       0x1800
-#define	RX_DESC_MIC_FAIL	  0x2000
-#define	RX_DESC_DECRYPT_FAIL	  0x4000
-
-struct wl12xx_rx_descriptor {
-	u32 timestamp; /* In microseconds */
-	u16 length; /* Paylod length, including headers */
-	u16 flags;
-
-	/*
-	 * 0 - 802.11
-	 * 1 - 802.3
-	 * 2 - IP
-	 * 3 - Raw Codec
-	 */
-	u8 type;
-
-	/*
-	 * Recevied Rate:
-	 * 0x0A - 1MBPS
-	 * 0x14 - 2MBPS
-	 * 0x37 - 5_5MBPS
-	 * 0x0B - 6MBPS
-	 * 0x0F - 9MBPS
-	 * 0x6E - 11MBPS
-	 * 0x0A - 12MBPS
-	 * 0x0E - 18MBPS
-	 * 0xDC - 22MBPS
-	 * 0x09 - 24MBPS
-	 * 0x0D - 36MBPS
-	 * 0x08 - 48MBPS
-	 * 0x0C - 54MBPS
-	 */
-	u8 rate;
-
-	u8 mod_pre; /* Modulation and preamble */
-	u8 channel;
-
-	/*
-	 * 0 - 2.4 Ghz
-	 * 1 - 5 Ghz
-	 */
-	u8 band;
-
-	s8 rssi; /* in dB */
-	u8 rcpi; /* in dB */
-	u8 snr; /* in dB */
-} __attribute__ ((packed));
-
-void wl12xx_rx(struct wl12xx *wl);
-
-#endif
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
deleted file mode 100644
index 9c9943f..0000000
--- a/drivers/net/wireless/wl12xx/spi.c
+++ /dev/null
@@ -1,395 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/crc7.h>
-#include <linux/spi/spi.h>
-
-#include "wl12xx.h"
-#include "wl12xx_80211.h"
-#include "reg.h"
-#include "spi.h"
-#include "ps.h"
-
-static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
-{
-	/* If the address is lower than REGISTERS_BASE, it means that this is
-	 * a chip-specific register address, so look it up in the registers
-	 * table */
-	if (addr < REGISTERS_BASE) {
-		/* Make sure we don't go over the table */
-		if (addr >= ACX_REG_TABLE_LEN) {
-			wl12xx_error("address out of range (%d)", addr);
-			return -EINVAL;
-		}
-		addr = wl->chip.acx_reg_table[addr];
-	}
-
-	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
-}
-
-static int wl12xx_translate_mem_addr(struct wl12xx *wl, int addr)
-{
-	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
-}
-
-
-void wl12xx_spi_reset(struct wl12xx *wl)
-{
-	u8 *cmd;
-	struct spi_transfer t;
-	struct spi_message m;
-
-	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
-	if (!cmd) {
-		wl12xx_error("could not allocate cmd for spi reset");
-		return;
-	}
-
-	memset(&t, 0, sizeof(t));
-	spi_message_init(&m);
-
-	memset(cmd, 0xff, WSPI_INIT_CMD_LEN);
-
-	t.tx_buf = cmd;
-	t.len = WSPI_INIT_CMD_LEN;
-	spi_message_add_tail(&t, &m);
-
-	spi_sync(wl->spi, &m);
-
-	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
-}
-
-void wl12xx_spi_init(struct wl12xx *wl)
-{
-	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
-	struct spi_transfer t;
-	struct spi_message m;
-
-	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
-	if (!cmd) {
-		wl12xx_error("could not allocate cmd for spi init");
-		return;
-	}
-
-	memset(crc, 0, sizeof(crc));
-	memset(&t, 0, sizeof(t));
-	spi_message_init(&m);
-
-	/*
-	 * Set WSPI_INIT_COMMAND
-	 * the data is being send from the MSB to LSB
-	 */
-	cmd[2] = 0xff;
-	cmd[3] = 0xff;
-	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
-	cmd[0] = 0;
-	cmd[7] = 0;
-	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
-	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
-
-	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
-		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
-	else
-		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
-
-	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
-		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
-
-	crc[0] = cmd[1];
-	crc[1] = cmd[0];
-	crc[2] = cmd[7];
-	crc[3] = cmd[6];
-	crc[4] = cmd[5];
-
-	cmd[4] |= crc7(0, crc, WSPI_INIT_CMD_CRC_LEN) << 1;
-	cmd[4] |= WSPI_INIT_CMD_END;
-
-	t.tx_buf = cmd;
-	t.len = WSPI_INIT_CMD_LEN;
-	spi_message_add_tail(&t, &m);
-
-	spi_sync(wl->spi, &m);
-
-	wl12xx_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
-}
-
-/* Set the SPI partitions to access the chip addresses
- *
- * There are two VIRTUAL (SPI) partitions (the memory partition and the
- * registers partition), which are mapped to two different areas of the
- * PHYSICAL (hardware) memory.  This function also makes other checks to
- * ensure that the partitions are not overlapping.  In the diagram below, the
- * memory partition comes before the register partition, but the opposite is
- * also supported.
- *
- *                               PHYSICAL address
- *                                     space
- *
- *                                    |    |
- *                                 ...+----+--> mem_start
- *          VIRTUAL address     ...   |    |
- *               space       ...      |    | [PART_0]
- *                        ...         |    |
- * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
- *               |    |         ...   |    |
- *               |MEM |      ...      |    |
- *               |    |   ...         |    |
- *  part_size <--+----+...            |    | {unused area)
- *               |    |   ...         |    |
- *               |REG |      ...      |    |
- *  part_size    |    |         ...   |    |
- *      +     <--+----+...         ...+----+--> reg_start
- *  reg_size              ...         |    |
- *                           ...      |    | [PART_1]
- *                              ...   |    |
- *                                 ...+----+--> reg_start + reg_size
- *                                    |    |
- *
- */
-int wl12xx_set_partition(struct wl12xx *wl,
-			  u32 mem_start, u32 mem_size,
-			  u32 reg_start, u32 reg_size)
-{
-	struct wl12xx_partition *partition;
-	struct spi_transfer t;
-	struct spi_message m;
-	size_t len, cmd_len;
-	u32 *cmd;
-	int addr;
-
-	cmd_len = sizeof(u32) + 2 * sizeof(struct wl12xx_partition);
-	cmd = kzalloc(cmd_len, GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
-
-	spi_message_init(&m);
-	memset(&t, 0, sizeof(t));
-
-	partition = (struct wl12xx_partition *) (cmd + 1);
-	addr = HW_ACCESS_PART0_SIZE_ADDR;
-	len = 2 * sizeof(struct wl12xx_partition);
-
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-		     mem_start, mem_size);
-	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-		     reg_start, reg_size);
-
-	/* Make sure that the two partitions together don't exceed the
-	 * address range */
-	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
-		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
-			     " address range.  Truncating partition[0].");
-		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	if ((mem_start < reg_start) &&
-	    ((mem_start + mem_size) > reg_start)) {
-		/* Guarantee that the memory partition doesn't overlap the
-		 * registers partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
-			     "overlapping partition[1].  Adjusted.");
-		mem_size = reg_start - mem_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	} else if ((reg_start < mem_start) &&
-		   ((reg_start + reg_size) > mem_start)) {
-		/* Guarantee that the register partition doesn't overlap the
-		 * memory partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
-			     " overlapping partition[0].  Adjusted.");
-		reg_size = mem_start - reg_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	partition[0].start = mem_start;
-	partition[0].size  = mem_size;
-	partition[1].start = reg_start;
-	partition[1].size  = reg_size;
-
-	wl->physical_mem_addr = mem_start;
-	wl->physical_reg_addr = reg_start;
-
-	wl->virtual_mem_addr = 0;
-	wl->virtual_reg_addr = mem_size;
-
-	t.tx_buf = cmd;
-	t.len = cmd_len;
-	spi_message_add_tail(&t, &m);
-
-	spi_sync(wl->spi, &m);
-
-	kfree(cmd);
-
-	return 0;
-}
-
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
-		     size_t len, bool fixed)
-{
-	struct spi_transfer t[3];
-	struct spi_message m;
-	u8 *busy_buf;
-	u32 *cmd;
-
-	cmd = &wl->buffer_cmd;
-	busy_buf = wl->buffer_busyword;
-
-	*cmd = 0;
-	*cmd |= WSPI_CMD_READ;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	if (fixed)
-		*cmd |= WSPI_CMD_FIXED;
-
-	spi_message_init(&m);
-	memset(t, 0, sizeof(t));
-
-	t[0].tx_buf = cmd;
-	t[0].len = 4;
-	spi_message_add_tail(&t[0], &m);
-
-	/* Busy and non busy words read */
-	t[1].rx_buf = busy_buf;
-	t[1].len = WL12XX_BUSY_WORD_LEN;
-	spi_message_add_tail(&t[1], &m);
-
-	t[2].rx_buf = buf;
-	t[2].len = len;
-	spi_message_add_tail(&t[2], &m);
-
-	spi_sync(wl->spi, &m);
-
-	/* FIXME: check busy words */
-
-	wl12xx_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
-	wl12xx_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
-}
-
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
-		      size_t len, bool fixed)
-{
-	struct spi_transfer t[2];
-	struct spi_message m;
-	u32 *cmd;
-
-	cmd = &wl->buffer_cmd;
-
-	*cmd = 0;
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	if (fixed)
-		*cmd |= WSPI_CMD_FIXED;
-
-	spi_message_init(&m);
-	memset(t, 0, sizeof(t));
-
-	t[0].tx_buf = cmd;
-	t[0].len = sizeof(*cmd);
-	spi_message_add_tail(&t[0], &m);
-
-	t[1].tx_buf = buf;
-	t[1].len = len;
-	spi_message_add_tail(&t[1], &m);
-
-	spi_sync(wl->spi, &m);
-
-	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
-	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
-}
-
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf,
-			 size_t len)
-{
-	int physical;
-
-	physical = wl12xx_translate_mem_addr(wl, addr);
-
-	wl12xx_spi_read(wl, physical, buf, len, false);
-}
-
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
-			  size_t len)
-{
-	int physical;
-
-	physical = wl12xx_translate_mem_addr(wl, addr);
-
-	wl12xx_spi_write(wl, physical, buf, len, false);
-}
-
-void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
-			 bool fixed)
-{
-	int physical;
-
-	physical = wl12xx_translate_reg_addr(wl, addr);
-
-	wl12xx_spi_read(wl, physical, buf, len, fixed);
-}
-
-void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
-			  bool fixed)
-{
-	int physical;
-
-	physical = wl12xx_translate_reg_addr(wl, addr);
-
-	wl12xx_spi_write(wl, physical, buf, len, fixed);
-}
-
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
-{
-	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
-}
-
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val)
-{
-	wl12xx_write32(wl, wl12xx_translate_mem_addr(wl, addr), val);
-}
-
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr)
-{
-	return wl12xx_read32(wl, wl12xx_translate_reg_addr(wl, addr));
-}
-
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
-{
-	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
-}
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
deleted file mode 100644
index e48a552..0000000
--- a/drivers/net/wireless/wl12xx/spi.h
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_SPI_H__
-#define __WL12XX_SPI_H__
-
-#include "cmd.h"
-#include "acx.h"
-#include "reg.h"
-
-#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
-
-#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
-#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
-#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
-#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
-
-#define HW_ACCESS_REGISTER_SIZE             4
-
-#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
-
-#define WSPI_CMD_READ                 0x40000000
-#define WSPI_CMD_WRITE                0x00000000
-#define WSPI_CMD_FIXED                0x20000000
-#define WSPI_CMD_BYTE_LENGTH          0x1FFE0000
-#define WSPI_CMD_BYTE_LENGTH_OFFSET   17
-#define WSPI_CMD_BYTE_ADDR            0x0001FFFF
-
-#define WSPI_INIT_CMD_CRC_LEN       5
-
-#define WSPI_INIT_CMD_START         0x00
-#define WSPI_INIT_CMD_TX            0x40
-/* the extra bypass bit is sampled by the TNET as '1' */
-#define WSPI_INIT_CMD_BYPASS_BIT    0x80
-#define WSPI_INIT_CMD_FIXEDBUSY_LEN 0x07
-#define WSPI_INIT_CMD_EN_FIXEDBUSY  0x80
-#define WSPI_INIT_CMD_DIS_FIXEDBUSY 0x00
-#define WSPI_INIT_CMD_IOD           0x40
-#define WSPI_INIT_CMD_IP            0x20
-#define WSPI_INIT_CMD_CS            0x10
-#define WSPI_INIT_CMD_WS            0x08
-#define WSPI_INIT_CMD_WSPI          0x01
-#define WSPI_INIT_CMD_END           0x01
-
-#define WSPI_INIT_CMD_LEN           8
-
-#define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
-		((WL12XX_BUSY_WORD_LEN - 4) / sizeof(u32))
-#define HW_ACCESS_WSPI_INIT_CMD_MASK  0
-
-
-/* Raw target IO, address is not translated */
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
-		      size_t len, bool fixed);
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
-		     size_t len, bool fixed);
-
-/* Memory target IO, address is tranlated to partition 0 */
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len);
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
-
-/* Registers IO */
-void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
-			 bool fixed);
-void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
-			  bool fixed);
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
-
-/* INIT and RESET words */
-void wl12xx_spi_reset(struct wl12xx *wl);
-void wl12xx_spi_init(struct wl12xx *wl);
-int wl12xx_set_partition(struct wl12xx *wl,
-			 u32 part_start, u32 part_size,
-			 u32 reg_start,  u32 reg_size);
-
-static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
-{
-	wl12xx_spi_read(wl, addr, &wl->buffer_32,
-			sizeof(wl->buffer_32), false);
-
-	return wl->buffer_32;
-}
-
-static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
-{
-	wl->buffer_32 = val;
-	wl12xx_spi_write(wl, addr, &wl->buffer_32,
-			 sizeof(wl->buffer_32), false);
-}
-
-#endif /* __WL12XX_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
new file mode 100644
index 0000000..cecc1fa
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -0,0 +1,841 @@
+#include "wl1251_acx.h"
+
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "wl1251_spi.h"
+#include "wl1251_ps.h"
+
+int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
+			   u8 mgt_rate, u8 mgt_mod)
+{
+	struct acx_fw_gen_frame_rates *rates;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx frame rates");
+
+	rates = kzalloc(sizeof(*rates), GFP_KERNEL);
+	if (!rates) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rates->tx_ctrl_frame_rate = ctrl_rate;
+	rates->tx_ctrl_frame_mod = ctrl_mod;
+	rates->tx_mgt_frame_rate = mgt_rate;
+	rates->tx_mgt_frame_mod = mgt_mod;
+
+	ret = wl12xx_cmd_configure(wl, ACX_FW_GEN_FRAME_RATES,
+				   rates, sizeof(*rates));
+	if (ret < 0) {
+		wl12xx_error("Failed to set FW rates and modulation");
+		goto out;
+	}
+
+out:
+	kfree(rates);
+	return ret;
+}
+
+
+int wl12xx_acx_station_id(struct wl12xx *wl)
+{
+	struct acx_dot11_station_id *mac;
+	int ret, i;
+
+	wl12xx_debug(DEBUG_ACX, "acx dot11_station_id");
+
+	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
+	if (!mac) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < ETH_ALEN; i++)
+		mac->mac[i] = wl->mac_addr[ETH_ALEN - 1 - i];
+
+	ret = wl12xx_cmd_configure(wl, DOT11_STATION_ID, mac, sizeof(*mac));
+	if (ret < 0)
+		goto out;
+
+out:
+	kfree(mac);
+	return ret;
+}
+
+int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id)
+{
+	struct acx_dot11_default_key *default_key;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx dot11_default_key (%d)", key_id);
+
+	default_key = kzalloc(sizeof(*default_key), GFP_KERNEL);
+	if (!default_key) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	default_key->id = key_id;
+
+	ret = wl12xx_cmd_configure(wl, DOT11_DEFAULT_KEY,
+				   default_key, sizeof(*default_key));
+	if (ret < 0) {
+		wl12xx_error("Couldnt set default key");
+		goto out;
+	}
+
+	wl->default_key = key_id;
+
+out:
+	kfree(default_key);
+	return ret;
+}
+
+int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
+				  u8 listen_interval)
+{
+	struct acx_wake_up_condition *wake_up;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx wake up conditions");
+
+	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
+	if (!wake_up) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wake_up->wake_up_event = wake_up_event;
+	wake_up->listen_interval = listen_interval;
+
+	ret = wl12xx_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
+				   wake_up, sizeof(*wake_up));
+	if (ret < 0) {
+		wl12xx_warning("could not set wake up conditions: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(wake_up);
+	return ret;
+}
+
+int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth)
+{
+	struct acx_sleep_auth *auth;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx sleep auth");
+
+	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
+	if (!auth) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	auth->sleep_auth = sleep_auth;
+
+	ret = wl12xx_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
+	if (ret < 0)
+		return ret;
+
+out:
+	kfree(auth);
+	return ret;
+}
+
+int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len)
+{
+	struct acx_revision *rev;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx fw rev");
+
+	rev = kzalloc(sizeof(*rev), GFP_KERNEL);
+	if (!rev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl12xx_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
+	if (ret < 0) {
+		wl12xx_warning("ACX_FW_REV interrogate failed");
+		goto out;
+	}
+
+	/* be careful with the buffer sizes */
+	strncpy(buf, rev->fw_version, min(len, sizeof(rev->fw_version)));
+
+	/*
+	 * if the firmware version string is exactly
+	 * sizeof(rev->fw_version) long or fw_len is less than
+	 * sizeof(rev->fw_version) it won't be null terminated
+	 */
+	buf[min(len, sizeof(rev->fw_version)) - 1] = '\0';
+
+out:
+	kfree(rev);
+	return ret;
+}
+
+int wl12xx_acx_tx_power(struct wl12xx *wl, int power)
+{
+	struct acx_current_tx_power *acx;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
+
+	if (power < 0 || power > 25)
+		return -EINVAL;
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->current_tx_power = power * 10;
+
+	ret = wl12xx_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl12xx_warning("configure of tx power failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl12xx_acx_feature_cfg(struct wl12xx *wl)
+{
+	struct acx_feature_config *feature;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx feature cfg");
+
+	feature = kzalloc(sizeof(*feature), GFP_KERNEL);
+	if (!feature) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
+	feature->data_flow_options = 0;
+	feature->options = 0;
+
+	ret = wl12xx_cmd_configure(wl, ACX_FEATURE_CFG,
+				   feature, sizeof(*feature));
+	if (ret < 0) {
+		wl12xx_error("Couldnt set HW encryption");
+		goto out;
+	}
+
+out:
+	kfree(feature);
+	return ret;
+}
+
+int wl12xx_acx_mem_map(struct wl12xx *wl, struct acx_header *mem_map,
+		       size_t len)
+{
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx mem map");
+
+	ret = wl12xx_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_acx_data_path_params(struct wl12xx *wl,
+				struct acx_data_path_params_resp *resp)
+{
+	struct acx_data_path_params *params;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx data path params");
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	params->rx_packet_ring_chunk_size = DP_RX_PACKET_RING_CHUNK_SIZE;
+	params->tx_packet_ring_chunk_size = DP_TX_PACKET_RING_CHUNK_SIZE;
+
+	params->rx_packet_ring_chunk_num = DP_RX_PACKET_RING_CHUNK_NUM;
+	params->tx_packet_ring_chunk_num = DP_TX_PACKET_RING_CHUNK_NUM;
+
+	params->tx_complete_threshold = 1;
+
+	params->tx_complete_ring_depth = FW_TX_CMPLT_BLOCK_SIZE;
+
+	params->tx_complete_timeout = DP_TX_COMPLETE_TIME_OUT;
+
+	ret = wl12xx_cmd_configure(wl, ACX_DATA_PATH_PARAMS,
+				   params, sizeof(*params));
+	if (ret < 0)
+		goto out;
+
+	/* FIXME: shouldn't this be ACX_DATA_PATH_RESP_PARAMS? */
+	ret = wl12xx_cmd_interrogate(wl, ACX_DATA_PATH_PARAMS,
+				     resp, sizeof(*resp));
+
+	if (ret < 0) {
+		wl12xx_warning("failed to read data path parameters: %d", ret);
+		goto out;
+	} else if (resp->header.cmd.status != CMD_STATUS_SUCCESS) {
+		wl12xx_warning("data path parameter acx status failed");
+		ret = -EIO;
+		goto out;
+	}
+
+out:
+	kfree(params);
+	return ret;
+}
+
+int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time)
+{
+	struct acx_rx_msdu_lifetime *acx;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx rx msdu life time");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->lifetime = life_time;
+	ret = wl12xx_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl12xx_warning("failed to set rx msdu life time: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter)
+{
+	struct acx_rx_config *rx_config;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx rx config");
+
+	rx_config = kzalloc(sizeof(*rx_config), GFP_KERNEL);
+	if (!rx_config) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rx_config->config_options = config;
+	rx_config->filter_options = filter;
+
+	ret = wl12xx_cmd_configure(wl, ACX_RX_CFG,
+				   rx_config, sizeof(*rx_config));
+	if (ret < 0) {
+		wl12xx_warning("failed to set rx config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(rx_config);
+	return ret;
+}
+
+int wl12xx_acx_pd_threshold(struct wl12xx *wl)
+{
+	struct acx_packet_detection *pd;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx data pd threshold");
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* FIXME: threshold value not set */
+
+	ret = wl12xx_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
+	if (ret < 0) {
+		wl12xx_warning("failed to set pd threshold: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(pd);
+	return 0;
+}
+
+int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time)
+{
+	struct acx_slot *slot;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx slot");
+
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	slot->wone_index = STATION_WONE_INDEX;
+	slot->slot_time = slot_time;
+
+	ret = wl12xx_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
+	if (ret < 0) {
+		wl12xx_warning("failed to set slot time: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(slot);
+	return ret;
+}
+
+int wl12xx_acx_group_address_tbl(struct wl12xx *wl)
+{
+	struct acx_dot11_grp_addr_tbl *acx;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx group address tbl");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* MAC filtering */
+	acx->enabled = 0;
+	acx->num_groups = 0;
+	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
+
+	ret = wl12xx_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl12xx_warning("failed to set group addr table: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl12xx_acx_service_period_timeout(struct wl12xx *wl)
+{
+	struct acx_rx_timeout *rx_timeout;
+	int ret;
+
+	rx_timeout = kzalloc(sizeof(*rx_timeout), GFP_KERNEL);
+	if (!rx_timeout) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl12xx_debug(DEBUG_ACX, "acx service period timeout");
+
+	rx_timeout->ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
+	rx_timeout->upsd_timeout = RX_TIMEOUT_UPSD_DEF;
+
+	ret = wl12xx_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
+				   rx_timeout, sizeof(*rx_timeout));
+	if (ret < 0) {
+		wl12xx_warning("failed to set service period timeout: %d",
+			       ret);
+		goto out;
+	}
+
+out:
+	kfree(rx_timeout);
+	return ret;
+}
+
+int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold)
+{
+	struct acx_rts_threshold *rts;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx rts threshold");
+
+	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
+	if (!rts) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rts->threshold = rts_threshold;
+
+	ret = wl12xx_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
+	if (ret < 0) {
+		wl12xx_warning("failed to set rts threshold: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(rts);
+	return ret;
+}
+
+int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl)
+{
+	struct acx_beacon_filter_option *beacon_filter;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx beacon filter opt");
+
+	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
+	if (!beacon_filter) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	beacon_filter->enable = 0;
+	beacon_filter->max_num_beacons = 0;
+
+	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
+				   beacon_filter, sizeof(*beacon_filter));
+	if (ret < 0) {
+		wl12xx_warning("failed to set beacon filter opt: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(beacon_filter);
+	return ret;
+}
+
+int wl12xx_acx_beacon_filter_table(struct wl12xx *wl)
+{
+	struct acx_beacon_filter_ie_table *ie_table;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx beacon filter table");
+
+	ie_table = kzalloc(sizeof(*ie_table), GFP_KERNEL);
+	if (!ie_table) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ie_table->num_ie = 0;
+	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
+
+	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
+				   ie_table, sizeof(*ie_table));
+	if (ret < 0) {
+		wl12xx_warning("failed to set beacon filter table: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(ie_table);
+	return ret;
+}
+
+int wl12xx_acx_sg_enable(struct wl12xx *wl)
+{
+	struct acx_bt_wlan_coex *pta;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx sg enable");
+
+	pta = kzalloc(sizeof(*pta), GFP_KERNEL);
+	if (!pta) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pta->enable = SG_ENABLE;
+
+	ret = wl12xx_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
+	if (ret < 0) {
+		wl12xx_warning("failed to set softgemini enable: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(pta);
+	return ret;
+}
+
+int wl12xx_acx_sg_cfg(struct wl12xx *wl)
+{
+	struct acx_bt_wlan_coex_param *param;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx sg cfg");
+
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* BT-WLAN coext parameters */
+	param->min_rate = RATE_INDEX_24MBPS;
+	param->bt_hp_max_time = PTA_BT_HP_MAXTIME_DEF;
+	param->wlan_hp_max_time = PTA_WLAN_HP_MAX_TIME_DEF;
+	param->sense_disable_timer = PTA_SENSE_DISABLE_TIMER_DEF;
+	param->rx_time_bt_hp = PTA_PROTECTIVE_RX_TIME_DEF;
+	param->tx_time_bt_hp = PTA_PROTECTIVE_TX_TIME_DEF;
+	param->rx_time_bt_hp_fast = PTA_PROTECTIVE_RX_TIME_FAST_DEF;
+	param->tx_time_bt_hp_fast = PTA_PROTECTIVE_TX_TIME_FAST_DEF;
+	param->wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
+	param->bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
+	param->next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
+	param->wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
+	param->hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
+	param->next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
+	param->antenna_type = PTA_ANTENNA_TYPE_DEF;
+	param->signal_type = PTA_SIGNALING_TYPE_DEF;
+	param->afh_leverage_on = PTA_AFH_LEVERAGE_ON_DEF;
+	param->quiet_cycle_num = PTA_NUMBER_QUIET_CYCLE_DEF;
+	param->max_cts = PTA_MAX_NUM_CTS_DEF;
+	param->wlan_packets_num = PTA_NUMBER_OF_WLAN_PACKETS_DEF;
+	param->bt_packets_num = PTA_NUMBER_OF_BT_PACKETS_DEF;
+	param->missed_rx_avalanche = PTA_RX_FOR_AVALANCHE_DEF;
+	param->wlan_elp_hp = PTA_ELP_HP_DEF;
+	param->bt_anti_starvation_cycles = PTA_ANTI_STARVE_NUM_CYCLE_DEF;
+	param->ack_mode_dual_ant = PTA_ACK_MODE_DEF;
+	param->pa_sd_enable = PTA_ALLOW_PA_SD_DEF;
+	param->pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
+	param->bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
+
+	ret = wl12xx_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
+	if (ret < 0) {
+		wl12xx_warning("failed to set sg config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(param);
+	return ret;
+}
+
+int wl12xx_acx_cca_threshold(struct wl12xx *wl)
+{
+	struct acx_energy_detection *detection;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx cca threshold");
+
+	detection = kzalloc(sizeof(*detection), GFP_KERNEL);
+	if (!detection) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	detection->rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
+	detection->tx_energy_detection = 0;
+
+	ret = wl12xx_cmd_configure(wl, ACX_CCA_THRESHOLD,
+				   detection, sizeof(*detection));
+	if (ret < 0) {
+		wl12xx_warning("failed to set cca threshold: %d", ret);
+		return ret;
+	}
+
+out:
+	kfree(detection);
+	return ret;
+}
+
+int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl)
+{
+	struct acx_beacon_broadcast *bb;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx bcn dtim options");
+
+	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
+	if (!bb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bb->beacon_rx_timeout = BCN_RX_TIMEOUT_DEF_VALUE;
+	bb->broadcast_timeout = BROADCAST_RX_TIMEOUT_DEF_VALUE;
+	bb->rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
+	bb->ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
+
+	ret = wl12xx_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
+	if (ret < 0) {
+		wl12xx_warning("failed to set rx config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(bb);
+	return ret;
+}
+
+int wl12xx_acx_aid(struct wl12xx *wl, u16 aid)
+{
+	struct acx_aid *acx_aid;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx aid");
+
+	acx_aid = kzalloc(sizeof(*acx_aid), GFP_KERNEL);
+	if (!acx_aid) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx_aid->aid = aid;
+
+	ret = wl12xx_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
+	if (ret < 0) {
+		wl12xx_warning("failed to set aid: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx_aid);
+	return ret;
+}
+
+int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask)
+{
+	struct acx_event_mask *mask;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx event mbox mask");
+
+	mask = kzalloc(sizeof(*mask), GFP_KERNEL);
+	if (!mask) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* high event mask is unused */
+	mask->high_event_mask = 0xffffffff;
+
+	mask->event_mask = event_mask;
+
+	ret = wl12xx_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
+				   mask, sizeof(*mask));
+	if (ret < 0) {
+		wl12xx_warning("failed to set acx_event_mbox_mask: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(mask);
+	return ret;
+}
+
+int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble)
+{
+	struct acx_preamble *acx;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx_set_preamble");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->preamble = preamble;
+
+	ret = wl12xx_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl12xx_warning("Setting of preamble failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl12xx_acx_cts_protect(struct wl12xx *wl,
+			   enum acx_ctsprotect_type ctsprotect)
+{
+	struct acx_ctsprotect *acx;
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx_set_ctsprotect");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->ctsprotect = ctsprotect;
+
+	ret = wl12xx_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl12xx_warning("Setting of ctsprotect failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime)
+{
+	struct acx_tsf_info *tsf_info;
+	int ret;
+
+	tsf_info = kzalloc(sizeof(*tsf_info), GFP_KERNEL);
+	if (!tsf_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl12xx_cmd_interrogate(wl, ACX_TSF_INFO,
+				     tsf_info, sizeof(*tsf_info));
+	if (ret < 0) {
+		wl12xx_warning("ACX_FW_REV interrogate failed");
+		goto out;
+	}
+
+	*mactime = tsf_info->current_tsf_lsb |
+		(tsf_info->current_tsf_msb << 31);
+
+out:
+	kfree(tsf_info);
+	return ret;
+}
+
+int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats)
+{
+	int ret;
+
+	wl12xx_debug(DEBUG_ACX, "acx statistics");
+
+	ret = wl12xx_cmd_interrogate(wl, ACX_STATISTICS, stats,
+				     sizeof(*stats));
+	if (ret < 0) {
+		wl12xx_warning("acx statistics failed: %d", ret);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
new file mode 100644
index 0000000..203f11f
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -0,0 +1,1146 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_ACX_H__
+#define __WL12XX_ACX_H__
+
+#include "wl12xx.h"
+#include "wl1251_cmd.h"
+
+/* Target's information element */
+struct acx_header {
+	struct wl12xx_cmd_header cmd;
+
+	/* acx (or information element) header */
+	u16 id;
+
+	/* payload length (not including headers */
+	u16 len;
+};
+
+struct acx_error_counter {
+	struct acx_header header;
+
+	/* The number of PLCP errors since the last time this */
+	/* information element was interrogated. This field is */
+	/* automatically cleared when it is interrogated.*/
+	u32 PLCP_error;
+
+	/* The number of FCS errors since the last time this */
+	/* information element was interrogated. This field is */
+	/* automatically cleared when it is interrogated.*/
+	u32 FCS_error;
+
+	/* The number of MPDUs without PLCP header errors received*/
+	/* since the last time this information element was interrogated. */
+	/* This field is automatically cleared when it is interrogated.*/
+	u32 valid_frame;
+
+	/* the number of missed sequence numbers in the squentially */
+	/* values of frames seq numbers */
+	u32 seq_num_miss;
+} __attribute__ ((packed));
+
+struct acx_revision {
+	struct acx_header header;
+
+	/*
+	 * The WiLink firmware version, an ASCII string x.x.x.x,
+	 * that uniquely identifies the current firmware.
+	 * The left most digit is incremented each time a
+	 * significant change is made to the firmware, such as
+	 * code redesign or new platform support.
+	 * The second digit is incremented when major enhancements
+	 * are added or major fixes are made.
+	 * The third digit is incremented for each GA release.
+	 * The fourth digit is incremented for each build.
+	 * The first two digits identify a firmware release version,
+	 * in other words, a unique set of features.
+	 * The first three digits identify a GA release.
+	 */
+	char fw_version[20];
+
+	/*
+	 * This 4 byte field specifies the WiLink hardware version.
+	 * bits 0  - 15: Reserved.
+	 * bits 16 - 23: Version ID - The WiLink version ID
+	 *              (1 = first spin, 2 = second spin, and so on).
+	 * bits 24 - 31: Chip ID - The WiLink chip ID.
+	 */
+	u32 hw_version;
+} __attribute__ ((packed));
+
+enum wl12xx_psm_mode {
+	/* Active mode */
+	WL12XX_PSM_CAM = 0,
+
+	/* Power save mode */
+	WL12XX_PSM_PS = 1,
+
+	/* Extreme low power */
+	WL12XX_PSM_ELP = 2,
+};
+
+struct acx_sleep_auth {
+	struct acx_header header;
+
+	/* The sleep level authorization of the device. */
+	/* 0 - Always active*/
+	/* 1 - Power down mode: light / fast sleep*/
+	/* 2 - ELP mode: Deep / Max sleep*/
+	u8  sleep_auth;
+	u8  padding[3];
+} __attribute__ ((packed));
+
+enum {
+	HOSTIF_PCI_MASTER_HOST_INDIRECT,
+	HOSTIF_PCI_MASTER_HOST_DIRECT,
+	HOSTIF_SLAVE,
+	HOSTIF_PKT_RING,
+	HOSTIF_DONTCARE = 0xFF
+};
+
+#define DEFAULT_UCAST_PRIORITY          0
+#define DEFAULT_RX_Q_PRIORITY           0
+#define DEFAULT_NUM_STATIONS            1
+#define DEFAULT_RXQ_PRIORITY            0 /* low 0 .. 15 high  */
+#define DEFAULT_RXQ_TYPE                0x07    /* All frames, Data/Ctrl/Mgmt */
+#define TRACE_BUFFER_MAX_SIZE           256
+
+#define  DP_RX_PACKET_RING_CHUNK_SIZE 1600
+#define  DP_TX_PACKET_RING_CHUNK_SIZE 1600
+#define  DP_RX_PACKET_RING_CHUNK_NUM 2
+#define  DP_TX_PACKET_RING_CHUNK_NUM 2
+#define  DP_TX_COMPLETE_TIME_OUT 20
+#define  FW_TX_CMPLT_BLOCK_SIZE 16
+
+struct acx_data_path_params {
+	struct acx_header header;
+
+	u16 rx_packet_ring_chunk_size;
+	u16 tx_packet_ring_chunk_size;
+
+	u8 rx_packet_ring_chunk_num;
+	u8 tx_packet_ring_chunk_num;
+
+	/*
+	 * Maximum number of packets that can be gathered
+	 * in the TX complete ring before an interrupt
+	 * is generated.
+	 */
+	u8 tx_complete_threshold;
+
+	/* Number of pending TX complete entries in cyclic ring.*/
+	u8 tx_complete_ring_depth;
+
+	/*
+	 * Max num microseconds since a packet enters the TX
+	 * complete ring until an interrupt is generated.
+	 */
+	u32 tx_complete_timeout;
+} __attribute__ ((packed));
+
+
+struct acx_data_path_params_resp {
+	struct acx_header header;
+
+	u16 rx_packet_ring_chunk_size;
+	u16 tx_packet_ring_chunk_size;
+
+	u8 rx_packet_ring_chunk_num;
+	u8 tx_packet_ring_chunk_num;
+
+	u8 pad[2];
+
+	u32 rx_packet_ring_addr;
+	u32 tx_packet_ring_addr;
+
+	u32 rx_control_addr;
+	u32 tx_control_addr;
+
+	u32 tx_complete_addr;
+} __attribute__ ((packed));
+
+#define TX_MSDU_LIFETIME_MIN       0
+#define TX_MSDU_LIFETIME_MAX       3000
+#define TX_MSDU_LIFETIME_DEF       512
+#define RX_MSDU_LIFETIME_MIN       0
+#define RX_MSDU_LIFETIME_MAX       0xFFFFFFFF
+#define RX_MSDU_LIFETIME_DEF       512000
+
+struct acx_rx_msdu_lifetime {
+	struct acx_header header;
+
+	/*
+	 * The maximum amount of time, in TU, before the
+	 * firmware discards the MSDU.
+	 */
+	u32 lifetime;
+} __attribute__ ((packed));
+
+/*
+ * RX Config Options Table
+ * Bit		Definition
+ * ===		==========
+ * 31:14		Reserved
+ * 13		Copy RX Status - when set, write three receive status words
+ * 	 	to top of rx'd MPDUs.
+ * 		When cleared, do not write three status words (added rev 1.5)
+ * 12		Reserved
+ * 11		RX Complete upon FCS error - when set, give rx complete
+ *	 	interrupt for FCS errors, after the rx filtering, e.g. unicast
+ *	 	frames not to us with FCS error will not generate an interrupt.
+ * 10		SSID Filter Enable - When set, the WiLink discards all beacon,
+ *	        probe request, and probe response frames with an SSID that does
+ *		not match the SSID specified by the host in the START/JOIN
+ *		command.
+ *		When clear, the WiLink receives frames with any SSID.
+ * 9		Broadcast Filter Enable - When set, the WiLink discards all
+ * 	 	broadcast frames. When clear, the WiLink receives all received
+ *		broadcast frames.
+ * 8:6		Reserved
+ * 5		BSSID Filter Enable - When set, the WiLink discards any frames
+ * 	 	with a BSSID that does not match the BSSID specified by the
+ *		host.
+ *		When clear, the WiLink receives frames from any BSSID.
+ * 4		MAC Addr Filter - When set, the WiLink discards any frames
+ * 	 	with a destination address that does not match the MAC address
+ *		of the adaptor.
+ *		When clear, the WiLink receives frames destined to any MAC
+ *		address.
+ * 3		Promiscuous - When set, the WiLink receives all valid frames
+ * 	 	(i.e., all frames that pass the FCS check).
+ *		When clear, only frames that pass the other filters specified
+ *		are received.
+ * 2		FCS - When set, the WiLink includes the FCS with the received
+ *	 	frame.
+ *		When cleared, the FCS is discarded.
+ * 1		PLCP header - When set, write all data from baseband to frame
+ * 	 	buffer including PHY header.
+ * 0		Reserved - Always equal to 0.
+ *
+ * RX Filter Options Table
+ * Bit		Definition
+ * ===		==========
+ * 31:12		Reserved - Always equal to 0.
+ * 11		Association - When set, the WiLink receives all association
+ * 	 	related frames (association request/response, reassocation
+ *		request/response, and disassociation). When clear, these frames
+ *		are discarded.
+ * 10		Auth/De auth - When set, the WiLink receives all authentication
+ * 	 	and de-authentication frames. When clear, these frames are
+ *		discarded.
+ * 9		Beacon - When set, the WiLink receives all beacon frames.
+ * 	 	When clear, these frames are discarded.
+ * 8		Contention Free - When set, the WiLink receives all contention
+ * 	 	free frames.
+ *		When clear, these frames are discarded.
+ * 7		Control - When set, the WiLink receives all control frames.
+ * 	 	When clear, these frames are discarded.
+ * 6		Data - When set, the WiLink receives all data frames.
+ * 	 	When clear, these frames are discarded.
+ * 5		FCS Error - When set, the WiLink receives frames that have FCS
+ *	 	errors.
+ *		When clear, these frames are discarded.
+ * 4		Management - When set, the WiLink receives all management
+ *		frames.
+ * 	 	When clear, these frames are discarded.
+ * 3		Probe Request - When set, the WiLink receives all probe request
+ * 	 	frames.
+ *		When clear, these frames are discarded.
+ * 2		Probe Response - When set, the WiLink receives all probe
+ * 		response frames.
+ *		When clear, these frames are discarded.
+ * 1		RTS/CTS/ACK - When set, the WiLink receives all RTS, CTS and ACK
+ * 	 	frames.
+ *		When clear, these frames are discarded.
+ * 0		Rsvd Type/Sub Type - When set, the WiLink receives all frames
+ * 	 	that have reserved frame types and sub types as defined by the
+ *		802.11 specification.
+ *		When clear, these frames are discarded.
+ */
+struct acx_rx_config {
+	struct acx_header header;
+
+	u32 config_options;
+	u32 filter_options;
+} __attribute__ ((packed));
+
+enum {
+	QOS_AC_BE = 0,
+	QOS_AC_BK,
+	QOS_AC_VI,
+	QOS_AC_VO,
+	QOS_HIGHEST_AC_INDEX = QOS_AC_VO,
+};
+
+#define MAX_NUM_OF_AC             (QOS_HIGHEST_AC_INDEX+1)
+#define FIRST_AC_INDEX            QOS_AC_BE
+#define MAX_NUM_OF_802_1d_TAGS    8
+#define AC_PARAMS_MAX_TSID        15
+#define MAX_APSD_CONF             0xffff
+
+#define  QOS_TX_HIGH_MIN      (0)
+#define  QOS_TX_HIGH_MAX      (100)
+
+#define  QOS_TX_HIGH_BK_DEF   (25)
+#define  QOS_TX_HIGH_BE_DEF   (35)
+#define  QOS_TX_HIGH_VI_DEF   (35)
+#define  QOS_TX_HIGH_VO_DEF   (35)
+
+#define  QOS_TX_LOW_BK_DEF    (15)
+#define  QOS_TX_LOW_BE_DEF    (25)
+#define  QOS_TX_LOW_VI_DEF    (25)
+#define  QOS_TX_LOW_VO_DEF    (25)
+
+struct acx_tx_queue_qos_config {
+	struct acx_header header;
+
+	u8 qid;
+	u8 pad[3];
+
+	/* Max number of blocks allowd in the queue */
+	u16 high_threshold;
+
+	/* Lowest memory blocks guaranteed for this queue */
+	u16 low_threshold;
+} __attribute__ ((packed));
+
+struct acx_packet_detection {
+	struct acx_header header;
+
+	u32 threshold;
+} __attribute__ ((packed));
+
+
+enum acx_slot_type {
+	SLOT_TIME_LONG = 0,
+	SLOT_TIME_SHORT = 1,
+	DEFAULT_SLOT_TIME = SLOT_TIME_SHORT,
+	MAX_SLOT_TIMES = 0xFF
+};
+
+#define STATION_WONE_INDEX 0
+
+struct acx_slot {
+	struct acx_header header;
+
+	u8 wone_index; /* Reserved */
+	u8 slot_time;
+	u8 reserved[6];
+} __attribute__ ((packed));
+
+
+#define ADDRESS_GROUP_MAX	(8)
+#define ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ADDRESS_GROUP_MAX)
+
+struct acx_dot11_grp_addr_tbl {
+	struct acx_header header;
+
+	u8 enabled;
+	u8 num_groups;
+	u8 pad[2];
+	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
+} __attribute__ ((packed));
+
+
+#define  RX_TIMEOUT_PS_POLL_MIN    0
+#define  RX_TIMEOUT_PS_POLL_MAX    (200000)
+#define  RX_TIMEOUT_PS_POLL_DEF    (15)
+#define  RX_TIMEOUT_UPSD_MIN       0
+#define  RX_TIMEOUT_UPSD_MAX       (200000)
+#define  RX_TIMEOUT_UPSD_DEF       (15)
+
+struct acx_rx_timeout {
+	struct acx_header header;
+
+	/*
+	 * The longest time the STA will wait to receive
+	 * traffic from the AP after a PS-poll has been
+	 * transmitted.
+	 */
+	u16 ps_poll_timeout;
+
+	/*
+	 * The longest time the STA will wait to receive
+	 * traffic from the AP after a frame has been sent
+	 * from an UPSD enabled queue.
+	 */
+	u16 upsd_timeout;
+} __attribute__ ((packed));
+
+#define RTS_THRESHOLD_MIN              0
+#define RTS_THRESHOLD_MAX              4096
+#define RTS_THRESHOLD_DEF              2347
+
+struct acx_rts_threshold {
+	struct acx_header header;
+
+	u16 threshold;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_beacon_filter_option {
+	struct acx_header header;
+
+	u8 enable;
+
+	/*
+	 * The number of beacons without the unicast TIM
+	 * bit set that the firmware buffers before
+	 * signaling the host about ready frames.
+	 * When set to 0 and the filter is enabled, beacons
+	 * without the unicast TIM bit set are dropped.
+	 */
+	u8 max_num_beacons;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+/*
+ * ACXBeaconFilterEntry (not 221)
+ * Byte Offset     Size (Bytes)    Definition
+ * ===========     ============    ==========
+ * 0				1               IE identifier
+ * 1               1               Treatment bit mask
+ *
+ * ACXBeaconFilterEntry (221)
+ * Byte Offset     Size (Bytes)    Definition
+ * ===========     ============    ==========
+ * 0               1               IE identifier
+ * 1               1               Treatment bit mask
+ * 2               3               OUI
+ * 5               1               Type
+ * 6               2               Version
+ *
+ *
+ * Treatment bit mask - The information element handling:
+ * bit 0 - The information element is compared and transferred
+ * in case of change.
+ * bit 1 - The information element is transferred to the host
+ * with each appearance or disappearance.
+ * Note that both bits can be set at the same time.
+ */
+#define	BEACON_FILTER_TABLE_MAX_IE_NUM		       (32)
+#define BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM (6)
+#define BEACON_FILTER_TABLE_IE_ENTRY_SIZE	       (2)
+#define BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE (6)
+#define BEACON_FILTER_TABLE_MAX_SIZE ((BEACON_FILTER_TABLE_MAX_IE_NUM * \
+			    BEACON_FILTER_TABLE_IE_ENTRY_SIZE) + \
+			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
+			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
+
+struct acx_beacon_filter_ie_table {
+	struct acx_header header;
+
+	u8 num_ie;
+	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
+	u8 pad[3];
+} __attribute__ ((packed));
+
+enum {
+	SG_ENABLE = 0,
+	SG_DISABLE,
+	SG_SENSE_NO_ACTIVITY,
+	SG_SENSE_ACTIVE
+};
+
+struct acx_bt_wlan_coex {
+	struct acx_header header;
+
+	/*
+	 * 0 -> PTA enabled
+	 * 1 -> PTA disabled
+	 * 2 -> sense no active mode, i.e.
+	 *      an interrupt is sent upon
+	 *      BT activity.
+	 * 3 -> PTA is switched on in response
+	 *      to the interrupt sending.
+	 */
+	u8 enable;
+	u8 pad[3];
+} __attribute__ ((packed));
+
+#define PTA_ANTENNA_TYPE_DEF		  (0)
+#define PTA_BT_HP_MAXTIME_DEF		  (2000)
+#define PTA_WLAN_HP_MAX_TIME_DEF	  (5000)
+#define PTA_SENSE_DISABLE_TIMER_DEF	  (1350)
+#define PTA_PROTECTIVE_RX_TIME_DEF	  (1500)
+#define PTA_PROTECTIVE_TX_TIME_DEF	  (1500)
+#define PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF (3000)
+#define PTA_SIGNALING_TYPE_DEF		  (1)
+#define PTA_AFH_LEVERAGE_ON_DEF		  (0)
+#define PTA_NUMBER_QUIET_CYCLE_DEF	  (0)
+#define PTA_MAX_NUM_CTS_DEF		  (3)
+#define PTA_NUMBER_OF_WLAN_PACKETS_DEF	  (2)
+#define PTA_NUMBER_OF_BT_PACKETS_DEF	  (2)
+#define PTA_PROTECTIVE_RX_TIME_FAST_DEF	  (1500)
+#define PTA_PROTECTIVE_TX_TIME_FAST_DEF	  (3000)
+#define PTA_CYCLE_TIME_FAST_DEF		  (8700)
+#define PTA_RX_FOR_AVALANCHE_DEF	  (5)
+#define PTA_ELP_HP_DEF			  (0)
+#define PTA_ANTI_STARVE_PERIOD_DEF	  (500)
+#define PTA_ANTI_STARVE_NUM_CYCLE_DEF	  (4)
+#define PTA_ALLOW_PA_SD_DEF		  (1)
+#define PTA_TIME_BEFORE_BEACON_DEF	  (6300)
+#define PTA_HPDM_MAX_TIME_DEF		  (1600)
+#define PTA_TIME_OUT_NEXT_WLAN_DEF	  (2550)
+#define PTA_AUTO_MODE_NO_CTS_DEF	  (0)
+#define PTA_BT_HP_RESPECTED_DEF		  (3)
+#define PTA_WLAN_RX_MIN_RATE_DEF	  (24)
+#define PTA_ACK_MODE_DEF		  (1)
+
+struct acx_bt_wlan_coex_param {
+	struct acx_header header;
+
+	/*
+	 * The minimum rate of a received WLAN packet in the STA,
+	 * during protective mode, of which a new BT-HP request
+	 * during this Rx will always be respected and gain the antenna.
+	 */
+	u32 min_rate;
+
+	/* Max time the BT HP will be respected. */
+	u16 bt_hp_max_time;
+
+	/* Max time the WLAN HP will be respected. */
+	u16 wlan_hp_max_time;
+
+	/*
+	 * The time between the last BT activity
+	 * and the moment when the sense mode returns
+	 * to SENSE_INACTIVE.
+	 */
+	u16 sense_disable_timer;
+
+	/* Time before the next BT HP instance */
+	u16 rx_time_bt_hp;
+	u16 tx_time_bt_hp;
+
+	/* range: 10-20000    default: 1500 */
+	u16 rx_time_bt_hp_fast;
+	u16 tx_time_bt_hp_fast;
+
+	/* range: 2000-65535  default: 8700 */
+	u16 wlan_cycle_fast;
+
+	/* range: 0 - 15000 (Msec) default: 1000 */
+	u16 bt_anti_starvation_period;
+
+	/* range 400-10000(Usec) default: 3000 */
+	u16 next_bt_lp_packet;
+
+	/* Deafult: worst case for BT DH5 traffic */
+	u16 wake_up_beacon;
+
+	/* range: 0-50000(Usec) default: 1050 */
+	u16 hp_dm_max_guard_time;
+
+	/*
+	 * This is to prevent both BT & WLAN antenna
+	 * starvation.
+	 * Range: 100-50000(Usec) default:2550
+	 */
+	u16 next_wlan_packet;
+
+	/* 0 -> shared antenna */
+	u8 antenna_type;
+
+	/*
+	 * 0 -> TI legacy
+	 * 1 -> Palau
+	 */
+	u8 signal_type;
+
+	/*
+	 * BT AFH status
+	 * 0 -> no AFH
+	 * 1 -> from dedicated GPIO
+	 * 2 -> AFH on (from host)
+	 */
+	u8 afh_leverage_on;
+
+	/*
+	 * The number of cycles during which no
+	 * TX will be sent after 1 cycle of RX
+	 * transaction in protective mode
+	 */
+	u8 quiet_cycle_num;
+
+	/*
+	 * The maximum number of CTSs that will
+	 * be sent for receiving RX packet in
+	 * protective mode
+	 */
+	u8 max_cts;
+
+	/*
+	 * The number of WLAN packets
+	 * transferred in common mode before
+	 * switching to BT.
+	 */
+	u8 wlan_packets_num;
+
+	/*
+	 * The number of BT packets
+	 * transferred in common mode before
+	 * switching to WLAN.
+	 */
+	u8 bt_packets_num;
+
+	/* range: 1-255  default: 5 */
+	u8 missed_rx_avalanche;
+
+	/* range: 0-1    default: 1 */
+	u8 wlan_elp_hp;
+
+	/* range: 0 - 15  default: 4 */
+	u8 bt_anti_starvation_cycles;
+
+	u8 ack_mode_dual_ant;
+
+	/*
+	 * Allow PA_SD assertion/de-assertion
+	 * during enabled BT activity.
+	 */
+	u8 pa_sd_enable;
+
+	/*
+	 * Enable/Disable PTA in auto mode:
+	 * Support Both Active & P.S modes
+	 */
+	u8 pta_auto_mode_enable;
+
+	/* range: 0 - 20  default: 1 */
+	u8 bt_hp_respected_num;
+} __attribute__ ((packed));
+
+#define CCA_THRSH_ENABLE_ENERGY_D       0x140A
+#define CCA_THRSH_DISABLE_ENERGY_D      0xFFEF
+
+struct acx_energy_detection {
+	struct acx_header header;
+
+	/* The RX Clear Channel Assessment threshold in the PHY */
+	u16 rx_cca_threshold;
+	u8 tx_energy_detection;
+	u8 pad;
+} __attribute__ ((packed));
+
+#define BCN_RX_TIMEOUT_DEF_VALUE        10000
+#define BROADCAST_RX_TIMEOUT_DEF_VALUE  20000
+#define RX_BROADCAST_IN_PS_DEF_VALUE    1
+#define CONSECUTIVE_PS_POLL_FAILURE_DEF 4
+
+struct acx_beacon_broadcast {
+	struct acx_header header;
+
+	u16 beacon_rx_timeout;
+	u16 broadcast_timeout;
+
+	/* Enables receiving of broadcast packets in PS mode */
+	u8 rx_broadcast_in_ps;
+
+	/* Consecutive PS Poll failures before updating the host */
+	u8 ps_poll_threshold;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_event_mask {
+	struct acx_header header;
+
+	u32 event_mask;
+	u32 high_event_mask; /* Unused */
+} __attribute__ ((packed));
+
+#define CFG_RX_FCS		BIT(2)
+#define CFG_RX_ALL_GOOD		BIT(3)
+#define CFG_UNI_FILTER_EN	BIT(4)
+#define CFG_BSSID_FILTER_EN	BIT(5)
+#define CFG_MC_FILTER_EN	BIT(6)
+#define CFG_MC_ADDR0_EN		BIT(7)
+#define CFG_MC_ADDR1_EN		BIT(8)
+#define CFG_BC_REJECT_EN	BIT(9)
+#define CFG_SSID_FILTER_EN	BIT(10)
+#define CFG_RX_INT_FCS_ERROR	BIT(11)
+#define CFG_RX_INT_ENCRYPTED	BIT(12)
+#define CFG_RX_WR_RX_STATUS	BIT(13)
+#define CFG_RX_FILTER_NULTI	BIT(14)
+#define CFG_RX_RESERVE		BIT(15)
+#define CFG_RX_TIMESTAMP_TSF	BIT(16)
+
+#define CFG_RX_RSV_EN		BIT(0)
+#define CFG_RX_RCTS_ACK		BIT(1)
+#define CFG_RX_PRSP_EN		BIT(2)
+#define CFG_RX_PREQ_EN		BIT(3)
+#define CFG_RX_MGMT_EN		BIT(4)
+#define CFG_RX_FCS_ERROR	BIT(5)
+#define CFG_RX_DATA_EN		BIT(6)
+#define CFG_RX_CTL_EN		BIT(7)
+#define CFG_RX_CF_EN		BIT(8)
+#define CFG_RX_BCN_EN		BIT(9)
+#define CFG_RX_AUTH_EN		BIT(10)
+#define CFG_RX_ASSOC_EN		BIT(11)
+
+#define SCAN_PASSIVE		BIT(0)
+#define SCAN_5GHZ_BAND		BIT(1)
+#define SCAN_TRIGGERED		BIT(2)
+#define SCAN_PRIORITY_HIGH	BIT(3)
+
+struct acx_fw_gen_frame_rates {
+	struct acx_header header;
+
+	u8 tx_ctrl_frame_rate; /* RATE_* */
+	u8 tx_ctrl_frame_mod; /* CCK_* or PBCC_* */
+	u8 tx_mgt_frame_rate;
+	u8 tx_mgt_frame_mod;
+} __attribute__ ((packed));
+
+/* STA MAC */
+struct acx_dot11_station_id {
+	struct acx_header header;
+
+	u8 mac[ETH_ALEN];
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_feature_config {
+	struct acx_header header;
+
+	u32 options;
+	u32 data_flow_options;
+} __attribute__ ((packed));
+
+struct acx_current_tx_power {
+	struct acx_header header;
+
+	u8  current_tx_power;
+	u8  padding[3];
+} __attribute__ ((packed));
+
+struct acx_dot11_default_key {
+	struct acx_header header;
+
+	u8 id;
+	u8 pad[3];
+} __attribute__ ((packed));
+
+struct acx_tsf_info {
+	struct acx_header header;
+
+	u32 current_tsf_msb;
+	u32 current_tsf_lsb;
+	u32 last_TBTT_msb;
+	u32 last_TBTT_lsb;
+	u8 last_dtim_count;
+	u8 pad[3];
+} __attribute__ ((packed));
+
+enum acx_wake_up_event {
+	WAKE_UP_EVENT_BEACON_BITMAP	= 0x01, /* Wake on every Beacon*/
+	WAKE_UP_EVENT_DTIM_BITMAP	= 0x02,	/* Wake on every DTIM*/
+	WAKE_UP_EVENT_N_DTIM_BITMAP	= 0x04, /* Wake on every Nth DTIM */
+	WAKE_UP_EVENT_N_BEACONS_BITMAP	= 0x08, /* Wake on every Nth Beacon */
+	WAKE_UP_EVENT_BITS_MASK		= 0x0F
+};
+
+struct acx_wake_up_condition {
+	struct acx_header header;
+
+	u8 wake_up_event; /* Only one bit can be set */
+	u8 listen_interval;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_aid {
+	struct acx_header header;
+
+	/*
+	 * To be set when associated with an AP.
+	 */
+	u16 aid;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+enum acx_preamble_type {
+	ACX_PREAMBLE_LONG = 0,
+	ACX_PREAMBLE_SHORT = 1
+};
+
+struct acx_preamble {
+	struct acx_header header;
+
+	/*
+	 * When set, the WiLink transmits the frames with a short preamble and
+	 * when cleared, the WiLink transmits the frames with a long preamble.
+	 */
+	u8 preamble;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+enum acx_ctsprotect_type {
+	CTSPROTECT_DISABLE = 0,
+	CTSPROTECT_ENABLE = 1
+};
+
+struct acx_ctsprotect {
+	struct acx_header header;
+	u8 ctsprotect;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+struct acx_tx_statistics {
+	u32 internal_desc_overflow;
+}  __attribute__ ((packed));
+
+struct acx_rx_statistics {
+	u32 out_of_mem;
+	u32 hdr_overflow;
+	u32 hw_stuck;
+	u32 dropped;
+	u32 fcs_err;
+	u32 xfr_hint_trig;
+	u32 path_reset;
+	u32 reset_counter;
+} __attribute__ ((packed));
+
+struct acx_dma_statistics {
+	u32 rx_requested;
+	u32 rx_errors;
+	u32 tx_requested;
+	u32 tx_errors;
+}  __attribute__ ((packed));
+
+struct acx_isr_statistics {
+	/* host command complete */
+	u32 cmd_cmplt;
+
+	/* fiqisr() */
+	u32 fiqs;
+
+	/* (INT_STS_ND & INT_TRIG_RX_HEADER) */
+	u32 rx_headers;
+
+	/* (INT_STS_ND & INT_TRIG_RX_CMPLT) */
+	u32 rx_completes;
+
+	/* (INT_STS_ND & INT_TRIG_NO_RX_BUF) */
+	u32 rx_mem_overflow;
+
+	/* (INT_STS_ND & INT_TRIG_S_RX_RDY) */
+	u32 rx_rdys;
+
+	/* irqisr() */
+	u32 irqs;
+
+	/* (INT_STS_ND & INT_TRIG_TX_PROC) */
+	u32 tx_procs;
+
+	/* (INT_STS_ND & INT_TRIG_DECRYPT_DONE) */
+	u32 decrypt_done;
+
+	/* (INT_STS_ND & INT_TRIG_DMA0) */
+	u32 dma0_done;
+
+	/* (INT_STS_ND & INT_TRIG_DMA1) */
+	u32 dma1_done;
+
+	/* (INT_STS_ND & INT_TRIG_TX_EXC_CMPLT) */
+	u32 tx_exch_complete;
+
+	/* (INT_STS_ND & INT_TRIG_COMMAND) */
+	u32 commands;
+
+	/* (INT_STS_ND & INT_TRIG_RX_PROC) */
+	u32 rx_procs;
+
+	/* (INT_STS_ND & INT_TRIG_PM_802) */
+	u32 hw_pm_mode_changes;
+
+	/* (INT_STS_ND & INT_TRIG_ACKNOWLEDGE) */
+	u32 host_acknowledges;
+
+	/* (INT_STS_ND & INT_TRIG_PM_PCI) */
+	u32 pci_pm;
+
+	/* (INT_STS_ND & INT_TRIG_ACM_WAKEUP) */
+	u32 wakeups;
+
+	/* (INT_STS_ND & INT_TRIG_LOW_RSSI) */
+	u32 low_rssi;
+} __attribute__ ((packed));
+
+struct acx_wep_statistics {
+	/* WEP address keys configured */
+	u32 addr_key_count;
+
+	/* default keys configured */
+	u32 default_key_count;
+
+	u32 reserved;
+
+	/* number of times that WEP key not found on lookup */
+	u32 key_not_found;
+
+	/* number of times that WEP key decryption failed */
+	u32 decrypt_fail;
+
+	/* WEP packets decrypted */
+	u32 packets;
+
+	/* WEP decrypt interrupts */
+	u32 interrupt;
+} __attribute__ ((packed));
+
+#define ACX_MISSED_BEACONS_SPREAD 10
+
+struct acx_pwr_statistics {
+	/* the amount of enters into power save mode (both PD & ELP) */
+	u32 ps_enter;
+
+	/* the amount of enters into ELP mode */
+	u32 elp_enter;
+
+	/* the amount of missing beacon interrupts to the host */
+	u32 missing_bcns;
+
+	/* the amount of wake on host-access times */
+	u32 wake_on_host;
+
+	/* the amount of wake on timer-expire */
+	u32 wake_on_timer_exp;
+
+	/* the number of packets that were transmitted with PS bit set */
+	u32 tx_with_ps;
+
+	/* the number of packets that were transmitted with PS bit clear */
+	u32 tx_without_ps;
+
+	/* the number of received beacons */
+	u32 rcvd_beacons;
+
+	/* the number of entering into PowerOn (power save off) */
+	u32 power_save_off;
+
+	/* the number of entries into power save mode */
+	u16 enable_ps;
+
+	/*
+	 * the number of exits from power save, not including failed PS
+	 * transitions
+	 */
+	u16 disable_ps;
+
+	/*
+	 * the number of times the TSF counter was adjusted because
+	 * of drift
+	 */
+	u32 fix_tsf_ps;
+
+	/* Gives statistics about the spread continuous missed beacons.
+	 * The 16 LSB are dedicated for the PS mode.
+	 * The 16 MSB are dedicated for the PS mode.
+	 * cont_miss_bcns_spread[0] - single missed beacon.
+	 * cont_miss_bcns_spread[1] - two continuous missed beacons.
+	 * cont_miss_bcns_spread[2] - three continuous missed beacons.
+	 * ...
+	 * cont_miss_bcns_spread[9] - ten and more continuous missed beacons.
+	*/
+	u32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
+
+	/* the number of beacons in awake mode */
+	u32 rcvd_awake_beacons;
+} __attribute__ ((packed));
+
+struct acx_mic_statistics {
+	u32 rx_pkts;
+	u32 calc_failure;
+} __attribute__ ((packed));
+
+struct acx_aes_statistics {
+	u32 encrypt_fail;
+	u32 decrypt_fail;
+	u32 encrypt_packets;
+	u32 decrypt_packets;
+	u32 encrypt_interrupt;
+	u32 decrypt_interrupt;
+} __attribute__ ((packed));
+
+struct acx_event_statistics {
+	u32 heart_beat;
+	u32 calibration;
+	u32 rx_mismatch;
+	u32 rx_mem_empty;
+	u32 rx_pool;
+	u32 oom_late;
+	u32 phy_transmit_error;
+	u32 tx_stuck;
+} __attribute__ ((packed));
+
+struct acx_ps_statistics {
+	u32 pspoll_timeouts;
+	u32 upsd_timeouts;
+	u32 upsd_max_sptime;
+	u32 upsd_max_apturn;
+	u32 pspoll_max_apturn;
+	u32 pspoll_utilization;
+	u32 upsd_utilization;
+} __attribute__ ((packed));
+
+struct acx_rxpipe_statistics {
+	u32 rx_prep_beacon_drop;
+	u32 descr_host_int_trig_rx_data;
+	u32 beacon_buffer_thres_host_int_trig_rx_data;
+	u32 missed_beacon_host_int_trig_rx_data;
+	u32 tx_xfr_host_int_trig_rx_data;
+} __attribute__ ((packed));
+
+struct acx_statistics {
+	struct acx_header header;
+
+	struct acx_tx_statistics tx;
+	struct acx_rx_statistics rx;
+	struct acx_dma_statistics dma;
+	struct acx_isr_statistics isr;
+	struct acx_wep_statistics wep;
+	struct acx_pwr_statistics pwr;
+	struct acx_aes_statistics aes;
+	struct acx_mic_statistics mic;
+	struct acx_event_statistics event;
+	struct acx_ps_statistics ps;
+	struct acx_rxpipe_statistics rxpipe;
+} __attribute__ ((packed));
+
+enum {
+	ACX_WAKE_UP_CONDITIONS      = 0x0002,
+	ACX_MEM_CFG                 = 0x0003,
+	ACX_SLOT                    = 0x0004,
+	ACX_QUEUE_HEAD              = 0x0005, /* for MASTER mode only */
+	ACX_AC_CFG                  = 0x0007,
+	ACX_MEM_MAP                 = 0x0008,
+	ACX_AID                     = 0x000A,
+	ACX_RADIO_PARAM             = 0x000B, /* Not used */
+	ACX_CFG                     = 0x000C, /* Not used */
+	ACX_FW_REV                  = 0x000D,
+	ACX_MEDIUM_USAGE            = 0x000F,
+	ACX_RX_CFG                  = 0x0010,
+	ACX_TX_QUEUE_CFG            = 0x0011, /* FIXME: only used by wl1251 */
+	ACX_BSS_IN_PS               = 0x0012, /* for AP only */
+	ACX_STATISTICS              = 0x0013, /* Debug API */
+	ACX_FEATURE_CFG             = 0x0015,
+	ACX_MISC_CFG                = 0x0017, /* Not used */
+	ACX_TID_CFG                 = 0x001A,
+	ACX_BEACON_FILTER_OPT       = 0x001F,
+	ACX_LOW_RSSI                = 0x0020,
+	ACX_NOISE_HIST              = 0x0021,
+	ACX_HDK_VERSION             = 0x0022, /* ??? */
+	ACX_PD_THRESHOLD            = 0x0023,
+	ACX_DATA_PATH_PARAMS        = 0x0024, /* WO */
+	ACX_DATA_PATH_RESP_PARAMS   = 0x0024, /* RO */
+	ACX_CCA_THRESHOLD           = 0x0025,
+	ACX_EVENT_MBOX_MASK         = 0x0026,
+#ifdef FW_RUNNING_AS_AP
+	ACX_DTIM_PERIOD             = 0x0027, /* for AP only */
+#else
+	ACX_WR_TBTT_AND_DTIM        = 0x0027, /* STA only */
+#endif
+	ACX_ACI_OPTION_CFG          = 0x0029, /* OBSOLETE (for 1251)*/
+	ACX_GPIO_CFG                = 0x002A, /* Not used */
+	ACX_GPIO_SET                = 0x002B, /* Not used */
+	ACX_PM_CFG                  = 0x002C, /* To Be Documented */
+	ACX_CONN_MONIT_PARAMS       = 0x002D,
+	ACX_AVERAGE_RSSI            = 0x002E, /* Not used */
+	ACX_CONS_TX_FAILURE         = 0x002F,
+	ACX_BCN_DTIM_OPTIONS        = 0x0031,
+	ACX_SG_ENABLE               = 0x0032,
+	ACX_SG_CFG                  = 0x0033,
+	ACX_ANTENNA_DIVERSITY_CFG   = 0x0035, /* To Be Documented */
+	ACX_LOW_SNR		    = 0x0037, /* To Be Documented */
+	ACX_BEACON_FILTER_TABLE     = 0x0038,
+	ACX_ARP_IP_FILTER           = 0x0039,
+	ACX_ROAMING_STATISTICS_TBL  = 0x003B,
+	ACX_RATE_POLICY             = 0x003D,
+	ACX_CTS_PROTECTION          = 0x003E,
+	ACX_SLEEP_AUTH              = 0x003F,
+	ACX_PREAMBLE_TYPE	    = 0x0040,
+	ACX_ERROR_CNT               = 0x0041,
+	ACX_FW_GEN_FRAME_RATES      = 0x0042,
+	ACX_IBSS_FILTER		    = 0x0044,
+	ACX_SERVICE_PERIOD_TIMEOUT  = 0x0045,
+	ACX_TSF_INFO                = 0x0046,
+	ACX_CONFIG_PS_WMM           = 0x0049,
+	ACX_ENABLE_RX_DATA_FILTER   = 0x004A,
+	ACX_SET_RX_DATA_FILTER      = 0x004B,
+	ACX_GET_DATA_FILTER_STATISTICS = 0x004C,
+	ACX_POWER_LEVEL_TABLE       = 0x004D,
+	ACX_BET_ENABLE              = 0x0050,
+	DOT11_STATION_ID            = 0x1001,
+	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
+	DOT11_CUR_TX_PWR            = 0x100D,
+	DOT11_DEFAULT_KEY           = 0x1010,
+	DOT11_RX_DOT11_MODE         = 0x1012,
+	DOT11_RTS_THRESHOLD         = 0x1013,
+	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
+
+	MAX_DOT11_IE = DOT11_GROUP_ADDRESS_TBL,
+
+	MAX_IE = 0xFFFF
+};
+
+
+int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
+			   u8 mgt_rate, u8 mgt_mod);
+int wl12xx_acx_station_id(struct wl12xx *wl);
+int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id);
+int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
+				  u8 listen_interval);
+int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth);
+int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len);
+int wl12xx_acx_tx_power(struct wl12xx *wl, int power);
+int wl12xx_acx_feature_cfg(struct wl12xx *wl);
+int wl12xx_acx_mem_map(struct wl12xx *wl,
+		       struct acx_header *mem_map, size_t len);
+int wl12xx_acx_data_path_params(struct wl12xx *wl,
+				struct acx_data_path_params_resp *data_path);
+int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time);
+int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter);
+int wl12xx_acx_pd_threshold(struct wl12xx *wl);
+int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time);
+int wl12xx_acx_group_address_tbl(struct wl12xx *wl);
+int wl12xx_acx_service_period_timeout(struct wl12xx *wl);
+int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold);
+int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl);
+int wl12xx_acx_beacon_filter_table(struct wl12xx *wl);
+int wl12xx_acx_sg_enable(struct wl12xx *wl);
+int wl12xx_acx_sg_cfg(struct wl12xx *wl);
+int wl12xx_acx_cca_threshold(struct wl12xx *wl);
+int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl);
+int wl12xx_acx_aid(struct wl12xx *wl, u16 aid);
+int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask);
+int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble);
+int wl12xx_acx_cts_protect(struct wl12xx *wl,
+			    enum acx_ctsprotect_type ctsprotect);
+int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats);
+int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime);
+
+#endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
new file mode 100644
index 0000000..c52a208
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -0,0 +1,297 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/gpio.h>
+
+#include "reg.h"
+#include "wl1251_boot.h"
+#include "wl1251_spi.h"
+#include "wl1251_event.h"
+
+static void wl12xx_boot_enable_interrupts(struct wl12xx *wl)
+{
+	enable_irq(wl->irq);
+}
+
+void wl12xx_boot_target_enable_interrupts(struct wl12xx *wl)
+{
+	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
+	wl12xx_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
+}
+
+int wl12xx_boot_soft_reset(struct wl12xx *wl)
+{
+	unsigned long timeout;
+	u32 boot_data;
+
+	/* perform soft reset */
+	wl12xx_reg_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+
+	/* SOFT_RESET is self clearing */
+	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
+	while (1) {
+		boot_data = wl12xx_reg_read32(wl, ACX_REG_SLV_SOFT_RESET);
+		wl12xx_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
+		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			/* 1.2 check pWhalBus->uSelfClearTime if the
+			 * timeout was reached */
+			wl12xx_error("soft reset timeout");
+			return -1;
+		}
+
+		udelay(SOFT_RESET_STALL_TIME);
+	}
+
+	/* disable Rx/Tx */
+	wl12xx_reg_write32(wl, ENABLE, 0x0);
+
+	/* disable auto calibration on start*/
+	wl12xx_reg_write32(wl, SPARE_A2, 0xffff);
+
+	return 0;
+}
+
+int wl12xx_boot_init_seq(struct wl12xx *wl)
+{
+	u32 scr_pad6, init_data, tmp, elp_cmd, ref_freq;
+
+	/*
+	 * col #1: INTEGER_DIVIDER
+	 * col #2: FRACTIONAL_DIVIDER
+	 * col #3: ATTN_BB
+	 * col #4: ALPHA_BB
+	 * col #5: STOP_TIME_BB
+	 * col #6: BB_PLL_LOOP_FILTER
+	 */
+	static const u32 LUT[REF_FREQ_NUM][LUT_PARAM_NUM] = {
+
+		{   83, 87381,  0xB, 5, 0xF00,  3}, /* REF_FREQ_19_2*/
+		{   61, 141154, 0xB, 5, 0x1450, 2}, /* REF_FREQ_26_0*/
+		{   41, 174763, 0xC, 6, 0x2D00, 1}, /* REF_FREQ_38_4*/
+		{   40, 0,      0xC, 6, 0x2EE0, 1}, /* REF_FREQ_40_0*/
+		{   47, 162280, 0xC, 6, 0x2760, 1}  /* REF_FREQ_33_6        */
+	};
+
+	/* read NVS params */
+	scr_pad6 = wl12xx_reg_read32(wl, SCR_PAD6);
+	wl12xx_debug(DEBUG_BOOT, "scr_pad6 0x%x", scr_pad6);
+
+	/* read ELP_CMD */
+	elp_cmd = wl12xx_reg_read32(wl, ELP_CMD);
+	wl12xx_debug(DEBUG_BOOT, "elp_cmd 0x%x", elp_cmd);
+
+	/* set the BB calibration time to be 300 usec (PLL_CAL_TIME) */
+	ref_freq = scr_pad6 & 0x000000FF;
+	wl12xx_debug(DEBUG_BOOT, "ref_freq 0x%x", ref_freq);
+
+	wl12xx_reg_write32(wl, PLL_CAL_TIME, 0x9);
+
+	/*
+	 * PG 1.2: set the clock buffer time to be 210 usec (CLK_BUF_TIME)
+	 */
+	wl12xx_reg_write32(wl, CLK_BUF_TIME, 0x6);
+
+	/*
+	 * set the clock detect feature to work in the restart wu procedure
+	 * (ELP_CFG_MODE[14]) and Select the clock source type
+	 * (ELP_CFG_MODE[13:12])
+	 */
+	tmp = ((scr_pad6 & 0x0000FF00) << 4) | 0x00004000;
+	wl12xx_reg_write32(wl, ELP_CFG_MODE, tmp);
+
+	/* PG 1.2: enable the BB PLL fix. Enable the PLL_LIMP_CLK_EN_CMD */
+	elp_cmd |= 0x00000040;
+	wl12xx_reg_write32(wl, ELP_CMD, elp_cmd);
+
+	/* PG 1.2: Set the BB PLL stable time to be 1000usec
+	 * (PLL_STABLE_TIME) */
+	wl12xx_reg_write32(wl, CFG_PLL_SYNC_CNT, 0x20);
+
+	/* PG 1.2: read clock request time */
+	init_data = wl12xx_reg_read32(wl, CLK_REQ_TIME);
+
+	/*
+	 * PG 1.2: set the clock request time to be ref_clk_settling_time -
+	 * 1ms = 4ms
+	 */
+	if (init_data > 0x21)
+		tmp = init_data - 0x21;
+	else
+		tmp = 0;
+	wl12xx_reg_write32(wl, CLK_REQ_TIME, tmp);
+
+	/* set BB PLL configurations in RF AFE */
+	wl12xx_reg_write32(wl, 0x003058cc, 0x4B5);
+
+	/* set RF_AFE_REG_5 */
+	wl12xx_reg_write32(wl, 0x003058d4, 0x50);
+
+	/* set RF_AFE_CTRL_REG_2 */
+	wl12xx_reg_write32(wl, 0x00305948, 0x11c001);
+
+	/*
+	 * change RF PLL and BB PLL divider for VCO clock and adjust VCO
+	 * bais current(RF_AFE_REG_13)
+	 */
+	wl12xx_reg_write32(wl, 0x003058f4, 0x1e);
+
+	/* set BB PLL configurations */
+	tmp = LUT[ref_freq][LUT_PARAM_INTEGER_DIVIDER] | 0x00017000;
+	wl12xx_reg_write32(wl, 0x00305840, tmp);
+
+	/* set fractional divider according to Appendix C-BB PLL
+	 * Calculations
+	 */
+	tmp = LUT[ref_freq][LUT_PARAM_FRACTIONAL_DIVIDER];
+	wl12xx_reg_write32(wl, 0x00305844, tmp);
+
+	/* set the initial data for the sigma delta */
+	wl12xx_reg_write32(wl, 0x00305848, 0x3039);
+
+	/*
+	 * set the accumulator attenuation value, calibration loop1
+	 * (alpha), calibration loop2 (beta), calibration loop3 (gamma) and
+	 * the VCO gain
+	 */
+	tmp = (LUT[ref_freq][LUT_PARAM_ATTN_BB] << 16) |
+		(LUT[ref_freq][LUT_PARAM_ALPHA_BB] << 12) | 0x1;
+	wl12xx_reg_write32(wl, 0x00305854, tmp);
+
+	/*
+	 * set the calibration stop time after holdoff time expires and set
+	 * settling time HOLD_OFF_TIME_BB
+	 */
+	tmp = LUT[ref_freq][LUT_PARAM_STOP_TIME_BB] | 0x000A0000;
+	wl12xx_reg_write32(wl, 0x00305858, tmp);
+
+	/*
+	 * set BB PLL Loop filter capacitor3- BB_C3[2:0] and set BB PLL
+	 * constant leakage current to linearize PFD to 0uA -
+	 * BB_ILOOPF[7:3]
+	 */
+	tmp = LUT[ref_freq][LUT_PARAM_BB_PLL_LOOP_FILTER] | 0x00000030;
+	wl12xx_reg_write32(wl, 0x003058f8, tmp);
+
+	/*
+	 * set regulator output voltage for n divider to
+	 * 1.35-BB_REFDIV[1:0], set charge pump current- BB_CPGAIN[4:2],
+	 * set BB PLL Loop filter capacitor2- BB_C2[7:5], set gain of BB
+	 * PLL auto-call to normal mode- BB_CALGAIN_3DB[8]
+	 */
+	wl12xx_reg_write32(wl, 0x003058f0, 0x29);
+
+	/* enable restart wakeup sequence (ELP_CMD[0]) */
+	wl12xx_reg_write32(wl, ELP_CMD, elp_cmd | 0x1);
+
+	/* restart sequence completed */
+	udelay(2000);
+
+	return 0;
+}
+
+int wl12xx_boot_run_firmware(struct wl12xx *wl)
+{
+	int loop, ret;
+	u32 chip_id, interrupt;
+
+	wl->chip.op_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
+
+	chip_id = wl12xx_reg_read32(wl, CHIP_ID_B);
+
+	wl12xx_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
+
+	if (chip_id != wl->chip.id) {
+		wl12xx_error("chip id doesn't match after firmware boot");
+		return -EIO;
+	}
+
+	/* wait for init to complete */
+	loop = 0;
+	while (loop++ < INIT_LOOP) {
+		udelay(INIT_LOOP_DELAY);
+		interrupt = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+
+		if (interrupt == 0xffffffff) {
+			wl12xx_error("error reading hardware complete "
+				     "init indication");
+			return -EIO;
+		}
+		/* check that ACX_INTR_INIT_COMPLETE is enabled */
+		else if (interrupt & wl->chip.intr_init_complete) {
+			wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+					   wl->chip.intr_init_complete);
+			break;
+		}
+	}
+
+	if (loop >= INIT_LOOP) {
+		wl12xx_error("timeout waiting for the hardware to "
+			     "complete initialization");
+		return -EIO;
+	}
+
+	/* get hardware config command mail box */
+	wl->cmd_box_addr = wl12xx_reg_read32(wl, REG_COMMAND_MAILBOX_PTR);
+
+	/* get hardware config event mail box */
+	wl->event_box_addr = wl12xx_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+
+	/* set the working partition to its "running" mode offset */
+	wl12xx_set_partition(wl,
+			     wl->chip.p_table[PART_WORK].mem.start,
+			     wl->chip.p_table[PART_WORK].mem.size,
+			     wl->chip.p_table[PART_WORK].reg.start,
+			     wl->chip.p_table[PART_WORK].reg.size);
+
+	wl12xx_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
+		     wl->cmd_box_addr, wl->event_box_addr);
+
+	wl->chip.op_fw_version(wl);
+
+	/*
+	 * in case of full asynchronous mode the firmware event must be
+	 * ready to receive event from the command mailbox
+	 */
+
+	/* enable gpio interrupts */
+	wl12xx_boot_enable_interrupts(wl);
+
+	wl->chip.op_target_enable_interrupts(wl);
+
+	/* unmask all mbox events  */
+	wl->event_mask = 0xffffffff;
+
+	ret = wl12xx_event_unmask(wl);
+	if (ret < 0) {
+		wl12xx_error("EVENT mask setting failed");
+		return ret;
+	}
+
+	wl12xx_event_mbox_config(wl);
+
+	/* firmware startup completed */
+	return 0;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.h b/drivers/net/wireless/wl12xx/wl1251_boot.h
new file mode 100644
index 0000000..4fa7313
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.h
@@ -0,0 +1,40 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __BOOT_H__
+#define __BOOT_H__
+
+#include "wl12xx.h"
+
+int wl12xx_boot_soft_reset(struct wl12xx *wl);
+int wl12xx_boot_init_seq(struct wl12xx *wl);
+int wl12xx_boot_run_firmware(struct wl12xx *wl);
+void wl12xx_boot_target_enable_interrupts(struct wl12xx *wl);
+
+/* number of times we try to read the INIT interrupt */
+#define INIT_LOOP 20000
+
+/* delay between retries */
+#define INIT_LOOP_DELAY 50
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
new file mode 100644
index 0000000..d0c2df6
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -0,0 +1,429 @@
+#include "wl1251_cmd.h"
+
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "wl1251_spi.h"
+#include "wl1251_ps.h"
+#include "wl1251_acx.h"
+
+/**
+ * send command to firmware
+ *
+ * @wl: wl struct
+ * @id: command id
+ * @buf: buffer containing the command, must work with dma
+ * @len: length of the buffer
+ */
+int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
+{
+	struct wl12xx_cmd_header *cmd;
+	unsigned long timeout;
+	u32 intr;
+	int ret = 0;
+
+	cmd = buf;
+	cmd->id = id;
+	cmd->status = 0;
+
+	WARN_ON(len % 4 != 0);
+
+	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
+
+	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+
+	timeout = jiffies + msecs_to_jiffies(WL12XX_COMMAND_TIMEOUT);
+
+	intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	while (!(intr & wl->chip.intr_cmd_complete)) {
+		if (time_after(jiffies, timeout)) {
+			wl12xx_error("command complete timeout");
+			ret = -ETIMEDOUT;
+			goto out;
+		}
+
+		msleep(1);
+
+		intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	}
+
+	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+			   wl->chip.intr_cmd_complete);
+
+out:
+	return ret;
+}
+
+/**
+ * send test command to firmware
+ *
+ * @wl: wl struct
+ * @buf: buffer containing the command, with all headers, must work with dma
+ * @len: length of the buffer
+ * @answer: is answer needed
+ */
+int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
+{
+	int ret;
+
+	wl12xx_debug(DEBUG_CMD, "cmd test");
+
+	ret = wl12xx_cmd_send(wl, CMD_TEST, buf, buf_len);
+
+	if (ret < 0) {
+		wl12xx_warning("TEST command failed");
+		return ret;
+	}
+
+	if (answer) {
+		struct wl12xx_command *cmd_answer;
+
+		/*
+		 * The test command got in, we can read the answer.
+		 * The answer would be a wl12xx_command, where the
+		 * parameter array contains the actual answer.
+		 */
+		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+
+		cmd_answer = buf;
+
+		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
+			wl12xx_error("TEST command answer error: %d",
+				     cmd_answer->header.status);
+	}
+
+	return 0;
+}
+
+/**
+ * read acx from firmware
+ *
+ * @wl: wl struct
+ * @id: acx id
+ * @buf: buffer for the response, including all headers, must work with dma
+ * @len: lenght of buf
+ */
+int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len)
+{
+	struct acx_header *acx = buf;
+	int ret;
+
+	wl12xx_debug(DEBUG_CMD, "cmd interrogate");
+
+	acx->id = id;
+
+	/* payload length, does not include any headers */
+	acx->len = len - sizeof(*acx);
+
+	ret = wl12xx_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl12xx_error("INTERROGATE command failed");
+		goto out;
+	}
+
+	/* the interrogate command got in, we can read the answer */
+	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
+
+	acx = buf;
+	if (acx->cmd.status != CMD_STATUS_SUCCESS)
+		wl12xx_error("INTERROGATE command error: %d",
+			     acx->cmd.status);
+
+out:
+	return ret;
+}
+
+/**
+ * write acx value to firmware
+ *
+ * @wl: wl struct
+ * @id: acx id
+ * @buf: buffer containing acx, including all headers, must work with dma
+ * @len: length of buf
+ */
+int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len)
+{
+	struct acx_header *acx = buf;
+	int ret;
+
+	wl12xx_debug(DEBUG_CMD, "cmd configure");
+
+	acx->id = id;
+
+	/* payload length, does not include any headers */
+	acx->len = len - sizeof(*acx);
+
+	ret = wl12xx_cmd_send(wl, CMD_CONFIGURE, acx, len);
+	if (ret < 0) {
+		wl12xx_warning("CONFIGURE command NOK");
+		return ret;
+	}
+
+	return 0;
+}
+
+int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
+		   void *bitmap, u16 bitmap_len, u8 bitmap_control)
+{
+	struct wl12xx_cmd_vbm_update *vbm;
+	int ret;
+
+	wl12xx_debug(DEBUG_CMD, "cmd vbm");
+
+	vbm = kzalloc(sizeof(*vbm), GFP_KERNEL);
+	if (!vbm) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Count and period will be filled by the target */
+	vbm->tim.bitmap_ctrl = bitmap_control;
+	if (bitmap_len > PARTIAL_VBM_MAX) {
+		wl12xx_warning("cmd vbm len is %d B, truncating to %d",
+			       bitmap_len, PARTIAL_VBM_MAX);
+		bitmap_len = PARTIAL_VBM_MAX;
+	}
+	memcpy(vbm->tim.pvb_field, bitmap, bitmap_len);
+	vbm->tim.identity = identity;
+	vbm->tim.length = bitmap_len + 3;
+
+	vbm->len = cpu_to_le16(bitmap_len + 5);
+
+	ret = wl12xx_cmd_send(wl, CMD_VBM, vbm, sizeof(*vbm));
+	if (ret < 0) {
+		wl12xx_error("VBM command failed");
+		goto out;
+	}
+
+out:
+	kfree(vbm);
+	return 0;
+}
+
+int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable)
+{
+	struct cmd_enabledisable_path *cmd;
+	int ret;
+	u16 cmd_rx, cmd_tx;
+
+	wl12xx_debug(DEBUG_CMD, "cmd data path");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->channel = channel;
+
+	if (enable) {
+		cmd_rx = CMD_ENABLE_RX;
+		cmd_tx = CMD_ENABLE_TX;
+	} else {
+		cmd_rx = CMD_DISABLE_RX;
+		cmd_tx = CMD_DISABLE_TX;
+	}
+
+	ret = wl12xx_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl12xx_error("rx %s cmd for channel %d failed",
+			     enable ? "start" : "stop", channel);
+		goto out;
+	}
+
+	wl12xx_debug(DEBUG_BOOT, "rx %s cmd channel %d",
+		     enable ? "start" : "stop", channel);
+
+	ret = wl12xx_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl12xx_error("tx %s cmd for channel %d failed",
+			     enable ? "start" : "stop", channel);
+		return ret;
+	}
+
+	wl12xx_debug(DEBUG_BOOT, "tx %s cmd channel %d",
+		     enable ? "start" : "stop", channel);
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
+int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+		    u16 beacon_interval, u8 wait)
+{
+	unsigned long timeout;
+	struct cmd_join *join;
+	int ret, i;
+	u8 *bssid;
+
+	join = kzalloc(sizeof(*join), GFP_KERNEL);
+	if (!join) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* FIXME: this should be in main.c */
+	ret = wl12xx_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
+				     DEFAULT_HW_GEN_MODULATION_TYPE,
+				     wl->tx_mgmt_frm_rate,
+				     wl->tx_mgmt_frm_mod);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_debug(DEBUG_CMD, "cmd join");
+
+	/* Reverse order BSSID */
+	bssid = (u8 *) &join->bssid_lsb;
+	for (i = 0; i < ETH_ALEN; i++)
+		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
+
+	join->rx_config_options = wl->rx_config;
+	join->rx_filter_options = wl->rx_filter;
+
+	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
+		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
+
+	join->beacon_interval = beacon_interval;
+	join->dtim_interval = dtim_interval;
+	join->bss_type = bss_type;
+	join->channel = wl->channel;
+	join->ctrl = JOIN_CMD_CTRL_TX_FLUSH;
+
+	ret = wl12xx_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
+	if (ret < 0) {
+		wl12xx_error("failed to initiate cmd join");
+		goto out;
+	}
+
+	timeout = msecs_to_jiffies(JOIN_TIMEOUT);
+
+	/*
+	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
+	 * simplify locking we just sleep instead, for now
+	 */
+	if (wait)
+		msleep(10);
+
+out:
+	kfree(join);
+	return ret;
+}
+
+int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode)
+{
+	struct wl12xx_cmd_ps_params *ps_params = NULL;
+	int ret = 0;
+
+	/* FIXME: this should be in ps.c */
+	ret = wl12xx_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
+					    wl->listen_int);
+	if (ret < 0) {
+		wl12xx_error("couldn't set wake up conditions");
+		goto out;
+	}
+
+	wl12xx_debug(DEBUG_CMD, "cmd set ps mode");
+
+	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
+	if (!ps_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ps_params->ps_mode = ps_mode;
+	ps_params->send_null_data = 1;
+	ps_params->retries = 5;
+	ps_params->hang_over_period = 128;
+	ps_params->null_data_rate = 1; /* 1 Mbps */
+
+	ret = wl12xx_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
+			      sizeof(*ps_params));
+	if (ret < 0) {
+		wl12xx_error("cmd set_ps_mode failed");
+		goto out;
+	}
+
+out:
+	kfree(ps_params);
+	return ret;
+}
+
+int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
+			   size_t len)
+{
+	struct cmd_read_write_memory *cmd;
+	int ret = 0;
+
+	wl12xx_debug(DEBUG_CMD, "cmd read memory");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	WARN_ON(len > MAX_READ_SIZE);
+	len = min_t(size_t, len, MAX_READ_SIZE);
+
+	cmd->addr = addr;
+	cmd->size = len;
+
+	ret = wl12xx_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl12xx_error("read memory command failed: %d", ret);
+		goto out;
+	}
+
+	/* the read command got in, we can now read the answer */
+	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
+
+	if (cmd->header.status != CMD_STATUS_SUCCESS)
+		wl12xx_error("error in read command result: %d",
+			     cmd->header.status);
+
+	memcpy(answer, cmd->value, len);
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
+int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
+			    void *buf, size_t buf_len)
+{
+	struct wl12xx_cmd_packet_template *cmd;
+	size_t cmd_len;
+	int ret = 0;
+
+	wl12xx_debug(DEBUG_CMD, "cmd template %d", cmd_id);
+
+	WARN_ON(buf_len > WL12XX_MAX_TEMPLATE_SIZE);
+	buf_len = min_t(size_t, buf_len, WL12XX_MAX_TEMPLATE_SIZE);
+	cmd_len = ALIGN(sizeof(*cmd) + buf_len, 4);
+
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->size = cpu_to_le16(buf_len);
+
+	if (buf)
+		memcpy(cmd->data, buf, buf_len);
+
+	ret = wl12xx_cmd_send(wl, cmd_id, cmd, cmd_len);
+	if (ret < 0) {
+		wl12xx_warning("cmd set_template failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
new file mode 100644
index 0000000..a2eae54
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -0,0 +1,407 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_CMD_H__
+#define __WL12XX_CMD_H__
+
+#include "wl12xx.h"
+
+struct acx_header;
+
+int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len);
+int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer);
+int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len);
+int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len);
+int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
+		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
+int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable);
+int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+		    u16 beacon_interval, u8 wait);
+int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode);
+int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
+			   size_t len);
+int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
+			    void *buf, size_t buf_len);
+
+/* unit ms */
+#define WL12XX_COMMAND_TIMEOUT 2000
+
+enum wl12xx_commands {
+	CMD_RESET           = 0,
+	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
+	CMD_CONFIGURE       = 2,    /*use this to write information elements*/
+	CMD_ENABLE_RX       = 3,
+	CMD_ENABLE_TX       = 4,
+	CMD_DISABLE_RX      = 5,
+	CMD_DISABLE_TX      = 6,
+	CMD_SCAN            = 8,
+	CMD_STOP_SCAN       = 9,
+	CMD_VBM             = 10,
+	CMD_START_JOIN      = 11,
+	CMD_SET_KEYS        = 12,
+	CMD_READ_MEMORY     = 13,
+	CMD_WRITE_MEMORY    = 14,
+	CMD_BEACON          = 19,
+	CMD_PROBE_RESP      = 20,
+	CMD_NULL_DATA       = 21,
+	CMD_PROBE_REQ       = 22,
+	CMD_TEST            = 23,
+	CMD_RADIO_CALIBRATE     = 25,   /* OBSOLETE */
+	CMD_ENABLE_RX_PATH      = 27,   /* OBSOLETE */
+	CMD_NOISE_HIST      = 28,
+	CMD_RX_RESET        = 29,
+	CMD_PS_POLL         = 30,
+	CMD_QOS_NULL_DATA   = 31,
+	CMD_LNA_CONTROL     = 32,
+	CMD_SET_BCN_MODE    = 33,
+	CMD_MEASUREMENT      = 34,
+	CMD_STOP_MEASUREMENT = 35,
+	CMD_DISCONNECT       = 36,
+	CMD_SET_PS_MODE      = 37,
+	CMD_CHANNEL_SWITCH   = 38,
+	CMD_STOP_CHANNEL_SWICTH = 39,
+	CMD_AP_DISCOVERY     = 40,
+	CMD_STOP_AP_DISCOVERY = 41,
+	CMD_SPS_SCAN = 42,
+	CMD_STOP_SPS_SCAN = 43,
+	CMD_HEALTH_CHECK     = 45,
+	CMD_DEBUG            = 46,
+	CMD_TRIGGER_SCAN_TO  = 47,
+
+	NUM_COMMANDS,
+	MAX_COMMAND_ID = 0xFFFF,
+};
+
+#define MAX_CMD_PARAMS 572
+
+struct wl12xx_cmd_header {
+	u16 id;
+	u16 status;
+	/* payload */
+	u8 data[0];
+} __attribute__ ((packed));
+
+struct  wl12xx_command {
+	struct wl12xx_cmd_header header;
+	u8  parameters[MAX_CMD_PARAMS];
+};
+
+enum {
+	CMD_MAILBOX_IDLE              		=  0,
+	CMD_STATUS_SUCCESS            		=  1,
+	CMD_STATUS_UNKNOWN_CMD        		=  2,
+	CMD_STATUS_UNKNOWN_IE         		=  3,
+	CMD_STATUS_REJECT_MEAS_SG_ACTIVE 	= 11,
+	CMD_STATUS_RX_BUSY            		= 13,
+	CMD_STATUS_INVALID_PARAM      		= 14,
+	CMD_STATUS_TEMPLATE_TOO_LARGE 		= 15,
+	CMD_STATUS_OUT_OF_MEMORY      		= 16,
+	CMD_STATUS_STA_TABLE_FULL     		= 17,
+	CMD_STATUS_RADIO_ERROR        		= 18,
+	CMD_STATUS_WRONG_NESTING      		= 19,
+	CMD_STATUS_TIMEOUT            		= 21, /* Driver internal use.*/
+	CMD_STATUS_FW_RESET           		= 22, /* Driver internal use.*/
+	MAX_COMMAND_STATUS            		= 0xff
+};
+
+
+/*
+ * CMD_READ_MEMORY
+ *
+ * The host issues this command to read the WiLink device memory/registers.
+ *
+ * Note: The Base Band address has special handling (16 bits registers and
+ * addresses). For more information, see the hardware specification.
+ */
+/*
+ * CMD_WRITE_MEMORY
+ *
+ * The host issues this command to write the WiLink device memory/registers.
+ *
+ * The Base Band address has special handling (16 bits registers and
+ * addresses). For more information, see the hardware specification.
+ */
+#define MAX_READ_SIZE 256
+
+struct cmd_read_write_memory {
+	struct wl12xx_cmd_header header;
+
+	/* The address of the memory to read from or write to.*/
+	u32 addr;
+
+	/* The amount of data in bytes to read from or write to the WiLink
+	 * device.*/
+	u32 size;
+
+	/* The actual value read from or written to the Wilink. The source
+	   of this field is the Host in WRITE command or the Wilink in READ
+	   command. */
+	u8 value[MAX_READ_SIZE];
+};
+
+#define CMDMBOX_HEADER_LEN 4
+#define CMDMBOX_INFO_ELEM_HEADER_LEN 4
+
+
+struct basic_scan_parameters {
+	u32 rx_config_options;
+	u32 rx_filter_options;
+
+	/*
+	 * Scan options:
+	 * bit 0: When this bit is set, passive scan.
+	 * bit 1: Band, when this bit is set we scan
+	 * in the 5Ghz band.
+	 * bit 2: voice mode, 0 for normal scan.
+	 * bit 3: scan priority, 1 for high priority.
+	 */
+	u16 scan_options;
+
+	/* Number of channels to scan */
+	u8 num_channels;
+
+	/* Number opf probe requests to send, per channel */
+	u8 num_probe_requests;
+
+	/* Rate and modulation for probe requests */
+	u16 tx_rate;
+
+	u8 tid_trigger;
+	u8 ssid_len;
+	u32 ssid[8];
+
+} __attribute__ ((packed));
+
+struct basic_scan_channel_parameters {
+	u32 min_duration; /* in TU */
+	u32 max_duration; /* in TU */
+	u32 bssid_lsb;
+	u16 bssid_msb;
+
+	/*
+	 * bits 0-3: Early termination count.
+	 * bits 4-5: Early termination condition.
+	 */
+	u8 early_termination;
+
+	u8 tx_power_att;
+	u8 channel;
+	u8 pad[3];
+} __attribute__ ((packed));
+
+/* SCAN parameters */
+#define SCAN_MAX_NUM_OF_CHANNELS 16
+
+struct cmd_scan {
+	struct wl12xx_cmd_header header;
+
+	struct basic_scan_parameters params;
+	struct basic_scan_channel_parameters channels[SCAN_MAX_NUM_OF_CHANNELS];
+} __attribute__ ((packed));
+
+enum {
+	BSS_TYPE_IBSS = 0,
+	BSS_TYPE_STA_BSS = 2,
+	BSS_TYPE_AP_BSS = 3,
+	MAX_BSS_TYPE = 0xFF
+};
+
+#define JOIN_CMD_CTRL_TX_FLUSH             0x80 /* Firmware flushes all Tx */
+#define JOIN_CMD_CTRL_EARLY_WAKEUP_ENABLE  0x01 /* Early wakeup time */
+
+
+struct cmd_join {
+	struct wl12xx_cmd_header header;
+
+	u32 bssid_lsb;
+	u16 bssid_msb;
+	u16 beacon_interval; /* in TBTTs */
+	u32 rx_config_options;
+	u32 rx_filter_options;
+
+	/*
+	 * The target uses this field to determine the rate at
+	 * which to transmit control frame responses (such as
+	 * ACK or CTS frames).
+	 */
+	u16 basic_rate_set;
+	u8 dtim_interval;
+	u8 tx_ctrl_frame_rate; /* OBSOLETE */
+	u8 tx_ctrl_frame_mod;  /* OBSOLETE */
+	/*
+	 * bits 0-2: This bitwise field specifies the type
+	 * of BSS to start or join (BSS_TYPE_*).
+	 * bit 4: Band - The radio band in which to join
+	 * or start.
+	 *  0 - 2.4GHz band
+	 *  1 - 5GHz band
+	 * bits 3, 5-7: Reserved
+	 */
+	u8 bss_type;
+	u8 channel;
+	u8 ssid_len;
+	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ctrl; /* JOIN_CMD_CTRL_* */
+	u8 tx_mgt_frame_rate; /* OBSOLETE */
+	u8 tx_mgt_frame_mod;  /* OBSOLETE */
+	u8 reserved;
+} __attribute__ ((packed));
+
+struct cmd_enabledisable_path {
+	struct wl12xx_cmd_header header;
+
+	u8 channel;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+#define WL12XX_MAX_TEMPLATE_SIZE 300
+
+struct wl12xx_cmd_packet_template {
+	struct wl12xx_cmd_header header;
+
+	__le16 size;
+	u8 data[0];
+} __attribute__ ((packed));
+
+#define TIM_ELE_ID    5
+#define PARTIAL_VBM_MAX    251
+
+struct wl12xx_tim {
+	u8 identity;
+	u8 length;
+	u8 dtim_count;
+	u8 dtim_period;
+	u8 bitmap_ctrl;
+	u8 pvb_field[PARTIAL_VBM_MAX]; /* Partial Virtual Bitmap */
+} __attribute__ ((packed));
+
+/* Virtual Bit Map update */
+struct wl12xx_cmd_vbm_update {
+	struct wl12xx_cmd_header header;
+	__le16 len;
+	u8  padding[2];
+	struct wl12xx_tim tim;
+} __attribute__ ((packed));
+
+enum wl12xx_cmd_ps_mode {
+	STATION_ACTIVE_MODE,
+	STATION_POWER_SAVE_MODE
+};
+
+struct wl12xx_cmd_ps_params {
+	struct wl12xx_cmd_header header;
+
+	u8 ps_mode; /* STATION_* */
+	u8 send_null_data; /* Do we have to send NULL data packet ? */
+	u8 retries; /* Number of retires for the initial NULL data packet */
+
+	 /*
+	  * TUs during which the target stays awake after switching
+	  * to power save mode.
+	  */
+	u8 hang_over_period;
+	u16 null_data_rate;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct wl12xx_cmd_trigger_scan_to {
+	struct wl12xx_cmd_header header;
+
+	u32 timeout;
+};
+
+/* HW encryption keys */
+#define NUM_ACCESS_CATEGORIES_COPY 4
+#define MAX_KEY_SIZE 32
+
+/* When set, disable HW encryption */
+#define DF_ENCRYPTION_DISABLE      0x01
+/* When set, disable HW decryption */
+#define DF_SNIFF_MODE_ENABLE       0x80
+
+enum wl12xx_cmd_key_action {
+	KEY_ADD_OR_REPLACE = 1,
+	KEY_REMOVE         = 2,
+	KEY_SET_ID         = 3,
+	MAX_KEY_ACTION     = 0xffff,
+};
+
+enum wl12xx_cmd_key_type {
+	KEY_WEP_DEFAULT       = 0,
+	KEY_WEP_ADDR          = 1,
+	KEY_AES_GROUP         = 4,
+	KEY_AES_PAIRWISE      = 5,
+	KEY_WEP_GROUP         = 6,
+	KEY_TKIP_MIC_GROUP    = 10,
+	KEY_TKIP_MIC_PAIRWISE = 11,
+};
+
+/*
+ *
+ * key_type_e   key size    key format
+ * ----------   ---------   ----------
+ * 0x00         5, 13, 29   Key data
+ * 0x01         5, 13, 29   Key data
+ * 0x04         16          16 bytes of key data
+ * 0x05         16          16 bytes of key data
+ * 0x0a         32          16 bytes of TKIP key data
+ *                          8 bytes of RX MIC key data
+ *                          8 bytes of TX MIC key data
+ * 0x0b         32          16 bytes of TKIP key data
+ *                          8 bytes of RX MIC key data
+ *                          8 bytes of TX MIC key data
+ *
+ */
+
+struct wl12xx_cmd_set_keys {
+	struct wl12xx_cmd_header header;
+
+	/* Ignored for default WEP key */
+	u8 addr[ETH_ALEN];
+
+	/* key_action_e */
+	u16 key_action;
+
+	u16 reserved_1;
+
+	/* key size in bytes */
+	u8 key_size;
+
+	/* key_type_e */
+	u8 key_type;
+	u8 ssid_profile;
+
+	/*
+	 * TKIP, AES: frame's key id field.
+	 * For WEP default key: key id;
+	 */
+	u8 id;
+	u8 reserved_2[6];
+	u8 key[MAX_KEY_SIZE];
+	u16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
+	u32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
+} __attribute__ ((packed));
+
+
+#endif /* __WL12XX_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
new file mode 100644
index 0000000..a63bc78
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -0,0 +1,518 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "wl1251_debugfs.h"
+
+#include <linux/skbuff.h>
+
+#include "wl12xx.h"
+#include "wl1251_acx.h"
+#include "wl1251_ps.h"
+
+/* ms */
+#define WL12XX_DEBUGFS_STATS_LIFETIME 1000
+
+/* debugfs macros idea from mac80211 */
+
+#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+static ssize_t name## _read(struct file *file, char __user *userbuf,	\
+			    size_t count, loff_t *ppos)			\
+{									\
+	struct wl12xx *wl = file->private_data;				\
+	char buf[buflen];						\
+	int res;							\
+									\
+	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static const struct file_operations name## _ops = {			\
+	.read = name## _read,						\
+	.open = wl12xx_open_file_generic,				\
+};
+
+#define DEBUGFS_ADD(name, parent)					\
+	wl->debugfs.name = debugfs_create_file(#name, 0400, parent,	\
+					       wl, &name## _ops);	\
+	if (IS_ERR(wl->debugfs.name)) {					\
+		ret = PTR_ERR(wl->debugfs.name);			\
+		wl->debugfs.name = NULL;				\
+		goto out;						\
+	}
+
+#define DEBUGFS_DEL(name)						\
+	do {								\
+		debugfs_remove(wl->debugfs.name);			\
+		wl->debugfs.name = NULL;				\
+	} while (0)
+
+#define DEBUGFS_FWSTATS_FILE(sub, name, buflen, fmt)			\
+static ssize_t sub## _ ##name## _read(struct file *file,		\
+				      char __user *userbuf,		\
+				      size_t count, loff_t *ppos)	\
+{									\
+	struct wl12xx *wl = file->private_data;				\
+	char buf[buflen];						\
+	int res;							\
+									\
+	wl12xx_debugfs_update_stats(wl);				\
+									\
+	res = scnprintf(buf, buflen, fmt "\n",				\
+			wl->stats.fw_stats->sub.name);			\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static const struct file_operations sub## _ ##name## _ops = {		\
+	.read = sub## _ ##name## _read,					\
+	.open = wl12xx_open_file_generic,				\
+};
+
+#define DEBUGFS_FWSTATS_ADD(sub, name)				\
+	DEBUGFS_ADD(sub## _ ##name, wl->debugfs.fw_statistics)
+
+#define DEBUGFS_FWSTATS_DEL(sub, name)				\
+	DEBUGFS_DEL(sub## _ ##name)
+
+static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
+{
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	if (wl->state == WL12XX_STATE_ON &&
+	    time_after(jiffies, wl->stats.fw_stats_update +
+		       msecs_to_jiffies(WL12XX_DEBUGFS_STATS_LIFETIME))) {
+		wl12xx_acx_statistics(wl, wl->stats.fw_stats);
+		wl->stats.fw_stats_update = jiffies;
+	}
+
+	wl12xx_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static int wl12xx_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(rx, out_of_mem, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, hw_stuck, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, dropped, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, fcs_err, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, path_reset, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, reset_counter, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(dma, rx_requested, 20, "%u");
+DEBUGFS_FWSTATS_FILE(dma, rx_errors, 20, "%u");
+DEBUGFS_FWSTATS_FILE(dma, tx_requested, 20, "%u");
+DEBUGFS_FWSTATS_FILE(dma, tx_errors, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, fiqs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_headers, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_rdys, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, irqs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, tx_procs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, decrypt_done, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, dma0_done, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, dma1_done, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, commands, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_procs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, pci_pm, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, wakeups, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, low_rssi, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(wep, addr_key_count, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, default_key_count, 20, "%u");
+/* skipping wep.reserved */
+DEBUGFS_FWSTATS_FILE(wep, key_not_found, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, packets, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, interrupt, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(pwr, ps_enter, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, elp_enter, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, power_save_off, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, enable_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, disable_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, 20, "%u");
+/* skipping cont_miss_bcns_spread for now */
+DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(mic, rx_pkts, 20, "%u");
+DEBUGFS_FWSTATS_FILE(mic, calc_failure, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(event, heart_beat, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, calibration, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_mismatch, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_pool, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, oom_late, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, tx_stuck, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data,
+		     20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, 20, "%u");
+
+DEBUGFS_READONLY_FILE(retry_count, 20, "%u", wl->stats.retry_count);
+DEBUGFS_READONLY_FILE(excessive_retries, 20, "%u",
+		      wl->stats.excessive_retries);
+
+static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct wl12xx *wl = file->private_data;
+	u32 queue_len;
+	char buf[20];
+	int res;
+
+	queue_len = skb_queue_len(&wl->tx_queue);
+
+	res = scnprintf(buf, sizeof(buf), "%u\n", queue_len);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+
+static const struct file_operations tx_queue_len_ops = {
+	.read = tx_queue_len_read,
+	.open = wl12xx_open_file_generic,
+};
+
+static void wl12xx_debugfs_delete_files(struct wl12xx *wl)
+{
+	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
+
+	DEBUGFS_FWSTATS_DEL(rx, out_of_mem);
+	DEBUGFS_FWSTATS_DEL(rx, hdr_overflow);
+	DEBUGFS_FWSTATS_DEL(rx, hw_stuck);
+	DEBUGFS_FWSTATS_DEL(rx, dropped);
+	DEBUGFS_FWSTATS_DEL(rx, fcs_err);
+	DEBUGFS_FWSTATS_DEL(rx, xfr_hint_trig);
+	DEBUGFS_FWSTATS_DEL(rx, path_reset);
+	DEBUGFS_FWSTATS_DEL(rx, reset_counter);
+
+	DEBUGFS_FWSTATS_DEL(dma, rx_requested);
+	DEBUGFS_FWSTATS_DEL(dma, rx_errors);
+	DEBUGFS_FWSTATS_DEL(dma, tx_requested);
+	DEBUGFS_FWSTATS_DEL(dma, tx_errors);
+
+	DEBUGFS_FWSTATS_DEL(isr, cmd_cmplt);
+	DEBUGFS_FWSTATS_DEL(isr, fiqs);
+	DEBUGFS_FWSTATS_DEL(isr, rx_headers);
+	DEBUGFS_FWSTATS_DEL(isr, rx_mem_overflow);
+	DEBUGFS_FWSTATS_DEL(isr, rx_rdys);
+	DEBUGFS_FWSTATS_DEL(isr, irqs);
+	DEBUGFS_FWSTATS_DEL(isr, tx_procs);
+	DEBUGFS_FWSTATS_DEL(isr, decrypt_done);
+	DEBUGFS_FWSTATS_DEL(isr, dma0_done);
+	DEBUGFS_FWSTATS_DEL(isr, dma1_done);
+	DEBUGFS_FWSTATS_DEL(isr, tx_exch_complete);
+	DEBUGFS_FWSTATS_DEL(isr, commands);
+	DEBUGFS_FWSTATS_DEL(isr, rx_procs);
+	DEBUGFS_FWSTATS_DEL(isr, hw_pm_mode_changes);
+	DEBUGFS_FWSTATS_DEL(isr, host_acknowledges);
+	DEBUGFS_FWSTATS_DEL(isr, pci_pm);
+	DEBUGFS_FWSTATS_DEL(isr, wakeups);
+	DEBUGFS_FWSTATS_DEL(isr, low_rssi);
+
+	DEBUGFS_FWSTATS_DEL(wep, addr_key_count);
+	DEBUGFS_FWSTATS_DEL(wep, default_key_count);
+	/* skipping wep.reserved */
+	DEBUGFS_FWSTATS_DEL(wep, key_not_found);
+	DEBUGFS_FWSTATS_DEL(wep, decrypt_fail);
+	DEBUGFS_FWSTATS_DEL(wep, packets);
+	DEBUGFS_FWSTATS_DEL(wep, interrupt);
+
+	DEBUGFS_FWSTATS_DEL(pwr, ps_enter);
+	DEBUGFS_FWSTATS_DEL(pwr, elp_enter);
+	DEBUGFS_FWSTATS_DEL(pwr, missing_bcns);
+	DEBUGFS_FWSTATS_DEL(pwr, wake_on_host);
+	DEBUGFS_FWSTATS_DEL(pwr, wake_on_timer_exp);
+	DEBUGFS_FWSTATS_DEL(pwr, tx_with_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, tx_without_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, rcvd_beacons);
+	DEBUGFS_FWSTATS_DEL(pwr, power_save_off);
+	DEBUGFS_FWSTATS_DEL(pwr, enable_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, disable_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, fix_tsf_ps);
+	/* skipping cont_miss_bcns_spread for now */
+	DEBUGFS_FWSTATS_DEL(pwr, rcvd_awake_beacons);
+
+	DEBUGFS_FWSTATS_DEL(mic, rx_pkts);
+	DEBUGFS_FWSTATS_DEL(mic, calc_failure);
+
+	DEBUGFS_FWSTATS_DEL(aes, encrypt_fail);
+	DEBUGFS_FWSTATS_DEL(aes, decrypt_fail);
+	DEBUGFS_FWSTATS_DEL(aes, encrypt_packets);
+	DEBUGFS_FWSTATS_DEL(aes, decrypt_packets);
+	DEBUGFS_FWSTATS_DEL(aes, encrypt_interrupt);
+	DEBUGFS_FWSTATS_DEL(aes, decrypt_interrupt);
+
+	DEBUGFS_FWSTATS_DEL(event, heart_beat);
+	DEBUGFS_FWSTATS_DEL(event, calibration);
+	DEBUGFS_FWSTATS_DEL(event, rx_mismatch);
+	DEBUGFS_FWSTATS_DEL(event, rx_mem_empty);
+	DEBUGFS_FWSTATS_DEL(event, rx_pool);
+	DEBUGFS_FWSTATS_DEL(event, oom_late);
+	DEBUGFS_FWSTATS_DEL(event, phy_transmit_error);
+	DEBUGFS_FWSTATS_DEL(event, tx_stuck);
+
+	DEBUGFS_FWSTATS_DEL(ps, pspoll_timeouts);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_timeouts);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_max_sptime);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_max_apturn);
+	DEBUGFS_FWSTATS_DEL(ps, pspoll_max_apturn);
+	DEBUGFS_FWSTATS_DEL(ps, pspoll_utilization);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_utilization);
+
+	DEBUGFS_FWSTATS_DEL(rxpipe, rx_prep_beacon_drop);
+	DEBUGFS_FWSTATS_DEL(rxpipe, descr_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_DEL(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_DEL(rxpipe, missed_beacon_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_DEL(rxpipe, tx_xfr_host_int_trig_rx_data);
+
+	DEBUGFS_DEL(tx_queue_len);
+	DEBUGFS_DEL(retry_count);
+	DEBUGFS_DEL(excessive_retries);
+}
+
+static int wl12xx_debugfs_add_files(struct wl12xx *wl)
+{
+	int ret = 0;
+
+	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
+
+	DEBUGFS_FWSTATS_ADD(rx, out_of_mem);
+	DEBUGFS_FWSTATS_ADD(rx, hdr_overflow);
+	DEBUGFS_FWSTATS_ADD(rx, hw_stuck);
+	DEBUGFS_FWSTATS_ADD(rx, dropped);
+	DEBUGFS_FWSTATS_ADD(rx, fcs_err);
+	DEBUGFS_FWSTATS_ADD(rx, xfr_hint_trig);
+	DEBUGFS_FWSTATS_ADD(rx, path_reset);
+	DEBUGFS_FWSTATS_ADD(rx, reset_counter);
+
+	DEBUGFS_FWSTATS_ADD(dma, rx_requested);
+	DEBUGFS_FWSTATS_ADD(dma, rx_errors);
+	DEBUGFS_FWSTATS_ADD(dma, tx_requested);
+	DEBUGFS_FWSTATS_ADD(dma, tx_errors);
+
+	DEBUGFS_FWSTATS_ADD(isr, cmd_cmplt);
+	DEBUGFS_FWSTATS_ADD(isr, fiqs);
+	DEBUGFS_FWSTATS_ADD(isr, rx_headers);
+	DEBUGFS_FWSTATS_ADD(isr, rx_mem_overflow);
+	DEBUGFS_FWSTATS_ADD(isr, rx_rdys);
+	DEBUGFS_FWSTATS_ADD(isr, irqs);
+	DEBUGFS_FWSTATS_ADD(isr, tx_procs);
+	DEBUGFS_FWSTATS_ADD(isr, decrypt_done);
+	DEBUGFS_FWSTATS_ADD(isr, dma0_done);
+	DEBUGFS_FWSTATS_ADD(isr, dma1_done);
+	DEBUGFS_FWSTATS_ADD(isr, tx_exch_complete);
+	DEBUGFS_FWSTATS_ADD(isr, commands);
+	DEBUGFS_FWSTATS_ADD(isr, rx_procs);
+	DEBUGFS_FWSTATS_ADD(isr, hw_pm_mode_changes);
+	DEBUGFS_FWSTATS_ADD(isr, host_acknowledges);
+	DEBUGFS_FWSTATS_ADD(isr, pci_pm);
+	DEBUGFS_FWSTATS_ADD(isr, wakeups);
+	DEBUGFS_FWSTATS_ADD(isr, low_rssi);
+
+	DEBUGFS_FWSTATS_ADD(wep, addr_key_count);
+	DEBUGFS_FWSTATS_ADD(wep, default_key_count);
+	/* skipping wep.reserved */
+	DEBUGFS_FWSTATS_ADD(wep, key_not_found);
+	DEBUGFS_FWSTATS_ADD(wep, decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(wep, packets);
+	DEBUGFS_FWSTATS_ADD(wep, interrupt);
+
+	DEBUGFS_FWSTATS_ADD(pwr, ps_enter);
+	DEBUGFS_FWSTATS_ADD(pwr, elp_enter);
+	DEBUGFS_FWSTATS_ADD(pwr, missing_bcns);
+	DEBUGFS_FWSTATS_ADD(pwr, wake_on_host);
+	DEBUGFS_FWSTATS_ADD(pwr, wake_on_timer_exp);
+	DEBUGFS_FWSTATS_ADD(pwr, tx_with_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, tx_without_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, rcvd_beacons);
+	DEBUGFS_FWSTATS_ADD(pwr, power_save_off);
+	DEBUGFS_FWSTATS_ADD(pwr, enable_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, disable_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, fix_tsf_ps);
+	/* skipping cont_miss_bcns_spread for now */
+	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_beacons);
+
+	DEBUGFS_FWSTATS_ADD(mic, rx_pkts);
+	DEBUGFS_FWSTATS_ADD(mic, calc_failure);
+
+	DEBUGFS_FWSTATS_ADD(aes, encrypt_fail);
+	DEBUGFS_FWSTATS_ADD(aes, decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(aes, encrypt_packets);
+	DEBUGFS_FWSTATS_ADD(aes, decrypt_packets);
+	DEBUGFS_FWSTATS_ADD(aes, encrypt_interrupt);
+	DEBUGFS_FWSTATS_ADD(aes, decrypt_interrupt);
+
+	DEBUGFS_FWSTATS_ADD(event, heart_beat);
+	DEBUGFS_FWSTATS_ADD(event, calibration);
+	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
+	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
+	DEBUGFS_FWSTATS_ADD(event, rx_pool);
+	DEBUGFS_FWSTATS_ADD(event, oom_late);
+	DEBUGFS_FWSTATS_ADD(event, phy_transmit_error);
+	DEBUGFS_FWSTATS_ADD(event, tx_stuck);
+
+	DEBUGFS_FWSTATS_ADD(ps, pspoll_timeouts);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_timeouts);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_max_sptime);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_max_apturn);
+	DEBUGFS_FWSTATS_ADD(ps, pspoll_max_apturn);
+	DEBUGFS_FWSTATS_ADD(ps, pspoll_utilization);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_utilization);
+
+	DEBUGFS_FWSTATS_ADD(rxpipe, rx_prep_beacon_drop);
+	DEBUGFS_FWSTATS_ADD(rxpipe, descr_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_ADD(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_ADD(rxpipe, missed_beacon_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
+
+	DEBUGFS_ADD(tx_queue_len, wl->debugfs.rootdir);
+	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
+	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
+
+out:
+	if (ret < 0)
+		wl12xx_debugfs_delete_files(wl);
+
+	return ret;
+}
+
+void wl12xx_debugfs_reset(struct wl12xx *wl)
+{
+	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
+	wl->stats.retry_count = 0;
+	wl->stats.excessive_retries = 0;
+}
+
+int wl12xx_debugfs_init(struct wl12xx *wl)
+{
+	int ret;
+
+	wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+
+	if (IS_ERR(wl->debugfs.rootdir)) {
+		ret = PTR_ERR(wl->debugfs.rootdir);
+		wl->debugfs.rootdir = NULL;
+		goto err;
+	}
+
+	wl->debugfs.fw_statistics = debugfs_create_dir("fw-statistics",
+						       wl->debugfs.rootdir);
+
+	if (IS_ERR(wl->debugfs.fw_statistics)) {
+		ret = PTR_ERR(wl->debugfs.fw_statistics);
+		wl->debugfs.fw_statistics = NULL;
+		goto err_root;
+	}
+
+	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats),
+				      GFP_KERNEL);
+
+	if (!wl->stats.fw_stats) {
+		ret = -ENOMEM;
+		goto err_fw;
+	}
+
+	wl->stats.fw_stats_update = jiffies;
+
+	ret = wl12xx_debugfs_add_files(wl);
+
+	if (ret < 0)
+		goto err_file;
+
+	return 0;
+
+err_file:
+	kfree(wl->stats.fw_stats);
+	wl->stats.fw_stats = NULL;
+
+err_fw:
+	debugfs_remove(wl->debugfs.fw_statistics);
+	wl->debugfs.fw_statistics = NULL;
+
+err_root:
+	debugfs_remove(wl->debugfs.rootdir);
+	wl->debugfs.rootdir = NULL;
+
+err:
+	return ret;
+}
+
+void wl12xx_debugfs_exit(struct wl12xx *wl)
+{
+	wl12xx_debugfs_delete_files(wl);
+
+	kfree(wl->stats.fw_stats);
+	wl->stats.fw_stats = NULL;
+
+	debugfs_remove(wl->debugfs.fw_statistics);
+	wl->debugfs.fw_statistics = NULL;
+
+	debugfs_remove(wl->debugfs.rootdir);
+	wl->debugfs.rootdir = NULL;
+
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.h b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
new file mode 100644
index 0000000..562cdcb
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
@@ -0,0 +1,33 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef WL12XX_DEBUGFS_H
+#define WL12XX_DEBUGFS_H
+
+#include "wl12xx.h"
+
+int wl12xx_debugfs_init(struct wl12xx *wl);
+void wl12xx_debugfs_exit(struct wl12xx *wl);
+void wl12xx_debugfs_reset(struct wl12xx *wl);
+
+#endif /* WL12XX_DEBUGFS_H */
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
new file mode 100644
index 0000000..50b5e43
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -0,0 +1,127 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "wl12xx.h"
+#include "reg.h"
+#include "wl1251_spi.h"
+#include "wl1251_event.h"
+#include "wl1251_ps.h"
+
+static int wl12xx_event_scan_complete(struct wl12xx *wl,
+				      struct event_mailbox *mbox)
+{
+	wl12xx_debug(DEBUG_EVENT, "status: 0x%x, channels: %d",
+		     mbox->scheduled_scan_status,
+		     mbox->scheduled_scan_channels);
+
+	if (wl->scanning) {
+		mutex_unlock(&wl->mutex);
+		ieee80211_scan_completed(wl->hw, false);
+		mutex_lock(&wl->mutex);
+		wl->scanning = false;
+	}
+
+	return 0;
+}
+
+static void wl12xx_event_mbox_dump(struct event_mailbox *mbox)
+{
+	wl12xx_debug(DEBUG_EVENT, "MBOX DUMP:");
+	wl12xx_debug(DEBUG_EVENT, "\tvector: 0x%x", mbox->events_vector);
+	wl12xx_debug(DEBUG_EVENT, "\tmask: 0x%x", mbox->events_mask);
+}
+
+static int wl12xx_event_process(struct wl12xx *wl, struct event_mailbox *mbox)
+{
+	int ret;
+	u32 vector;
+
+	wl12xx_event_mbox_dump(mbox);
+
+	vector = mbox->events_vector & ~(mbox->events_mask);
+	wl12xx_debug(DEBUG_EVENT, "vector: 0x%x", vector);
+
+	if (vector & SCAN_COMPLETE_EVENT_ID) {
+		ret = wl12xx_event_scan_complete(wl, mbox);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (vector & BSS_LOSE_EVENT_ID) {
+		wl12xx_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
+
+		if (wl->psm_requested && wl->psm) {
+			ret = wl12xx_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+int wl12xx_event_unmask(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_event_mbox_mask(wl, ~(wl->event_mask));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void wl12xx_event_mbox_config(struct wl12xx *wl)
+{
+	wl->mbox_ptr[0] = wl12xx_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
+
+	wl12xx_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
+		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
+}
+
+int wl12xx_event_handle(struct wl12xx *wl, u8 mbox_num)
+{
+	struct event_mailbox mbox;
+	int ret;
+
+	wl12xx_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
+
+	if (mbox_num > 1)
+		return -EINVAL;
+
+	/* first we read the mbox descriptor */
+	wl12xx_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+			    sizeof(struct event_mailbox));
+
+	/* process the descriptor */
+	ret = wl12xx_event_process(wl, &mbox);
+	if (ret < 0)
+		return ret;
+
+	/* then we let the firmware know it can go on...*/
+	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.h b/drivers/net/wireless/wl12xx/wl1251_event.h
new file mode 100644
index 0000000..1f4c2f7
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_event.h
@@ -0,0 +1,121 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_EVENT_H__
+#define __WL12XX_EVENT_H__
+
+/*
+ * Mbox events
+ *
+ * The event mechanism is based on a pair of event buffers (buffers A and
+ * B) at fixed locations in the target's memory. The host processes one
+ * buffer while the other buffer continues to collect events. If the host
+ * is not processing events, an interrupt is issued to signal that a buffer
+ * is ready. Once the host is done with processing events from one buffer,
+ * it signals the target (with an ACK interrupt) that the event buffer is
+ * free.
+ */
+
+enum {
+	RESERVED1_EVENT_ID                       = BIT(0),
+	RESERVED2_EVENT_ID                       = BIT(1),
+	MEASUREMENT_START_EVENT_ID               = BIT(2),
+	SCAN_COMPLETE_EVENT_ID                   = BIT(3),
+	CALIBRATION_COMPLETE_EVENT_ID            = BIT(4),
+	ROAMING_TRIGGER_LOW_RSSI_EVENT_ID        = BIT(5),
+	PS_REPORT_EVENT_ID                       = BIT(6),
+	SYNCHRONIZATION_TIMEOUT_EVENT_ID         = BIT(7),
+	HEALTH_REPORT_EVENT_ID                   = BIT(8),
+	ACI_DETECTION_EVENT_ID                   = BIT(9),
+	DEBUG_REPORT_EVENT_ID                    = BIT(10),
+	MAC_STATUS_EVENT_ID                      = BIT(11),
+	DISCONNECT_EVENT_COMPLETE_ID             = BIT(12),
+	JOIN_EVENT_COMPLETE_ID                   = BIT(13),
+	CHANNEL_SWITCH_COMPLETE_EVENT_ID         = BIT(14),
+	BSS_LOSE_EVENT_ID                        = BIT(15),
+	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID    = BIT(16),
+	MEASUREMENT_COMPLETE_EVENT_ID            = BIT(17),
+	AP_DISCOVERY_COMPLETE_EVENT_ID           = BIT(18),
+	SCHEDULED_SCAN_COMPLETE_EVENT_ID         = BIT(19),
+	PSPOLL_DELIVERY_FAILURE_EVENT_ID 	 = BIT(20),
+	RESET_BSS_EVENT_ID                       = BIT(21),
+	REGAINED_BSS_EVENT_ID                    = BIT(22),
+	ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID   = BIT(23),
+	ROAMING_TRIGGER_LOW_SNR_EVENT_ID         = BIT(24),
+	ROAMING_TRIGGER_REGAINED_SNR_EVENT_ID    = BIT(25),
+
+	DBG_EVENT_ID                             = BIT(26),
+	BT_PTA_SENSE_EVENT_ID                    = BIT(27),
+	BT_PTA_PREDICTION_EVENT_ID               = BIT(28),
+	BT_PTA_AVALANCHE_EVENT_ID                = BIT(29),
+
+	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID     = BIT(30),
+
+	EVENT_MBOX_ALL_EVENT_ID                  = 0x7fffffff,
+};
+
+struct event_debug_report {
+	u8 debug_event_id;
+	u8 num_params;
+	u16 pad;
+	u32 report_1;
+	u32 report_2;
+	u32 report_3;
+} __attribute__ ((packed));
+
+struct event_mailbox {
+	u32 events_vector;
+	u32 events_mask;
+	u32 reserved_1;
+	u32 reserved_2;
+
+	char average_rssi_level;
+	u8 ps_status;
+	u8 channel_switch_status;
+	u8 scheduled_scan_status;
+
+	/* Channels scanned by the scheduled scan */
+	u16 scheduled_scan_channels;
+
+	/* If bit 0 is set -> target's fatal error */
+	u16 health_report;
+	u16 bad_fft_counter;
+	u8 bt_pta_sense_info;
+	u8 bt_pta_protective_info;
+	u32 reserved;
+	u32 debug_report[2];
+
+	/* Number of FCS errors since last event */
+	u32 fcs_err_counter;
+
+	struct event_debug_report report;
+	u8 average_snr_level;
+	u8 padding[19];
+} __attribute__ ((packed));
+
+int wl12xx_event_unmask(struct wl12xx *wl);
+void wl12xx_event_mbox_config(struct wl12xx *wl);
+int wl12xx_event_handle(struct wl12xx *wl, u8 mbox);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
new file mode 100644
index 0000000..0929461
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -0,0 +1,200 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "wl1251_init.h"
+#include "wl12xx_80211.h"
+#include "wl1251_acx.h"
+#include "wl1251_cmd.h"
+
+int wl12xx_hw_init_hwenc_config(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_feature_cfg(wl);
+	if (ret < 0) {
+		wl12xx_warning("couldn't set feature config");
+		return ret;
+	}
+
+	ret = wl12xx_acx_default_key(wl, wl->default_key);
+	if (ret < 0) {
+		wl12xx_warning("couldn't set default key");
+		return ret;
+	}
+
+	return 0;
+}
+
+int wl12xx_hw_init_templates_config(struct wl12xx *wl)
+{
+	int ret;
+	u8 partial_vbm[PARTIAL_VBM_MAX];
+
+	/* send empty templates for fw memory reservation */
+	ret = wl12xx_cmd_template_set(wl, CMD_PROBE_REQ, NULL,
+				      sizeof(struct wl12xx_probe_req_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_template_set(wl, CMD_NULL_DATA, NULL,
+				      sizeof(struct wl12xx_null_data_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_template_set(wl, CMD_PS_POLL, NULL,
+				      sizeof(struct wl12xx_ps_poll_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_template_set(wl, CMD_QOS_NULL_DATA, NULL,
+				      sizeof
+				      (struct wl12xx_qos_null_data_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, NULL,
+				      sizeof
+				      (struct wl12xx_probe_resp_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_template_set(wl, CMD_BEACON, NULL,
+				      sizeof
+				      (struct wl12xx_beacon_template));
+	if (ret < 0)
+		return ret;
+
+	/* tim templates, first reserve space then allocate an empty one */
+	memset(partial_vbm, 0, PARTIAL_VBM_MAX);
+	ret = wl12xx_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, PARTIAL_VBM_MAX, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, 1, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter)
+{
+	int ret;
+
+	ret = wl12xx_acx_rx_msdu_life_time(wl, RX_MSDU_LIFETIME_DEF);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_rx_config(wl, config, filter);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_phy_config(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_pd_threshold(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_slot(wl, DEFAULT_SLOT_TIME);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_group_address_tbl(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_service_period_timeout(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_rts_threshold(wl, RTS_THRESHOLD_DEF);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_beacon_filter(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_beacon_filter_opt(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_beacon_filter_table(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_pta(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_sg_enable(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_acx_sg_cfg(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_energy_detection(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_cca_threshold(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_beacon_broadcast(struct wl12xx *wl)
+{
+	int ret;
+
+	ret = wl12xx_acx_bcn_dtim_options(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_hw_init_power_auth(struct wl12xx *wl)
+{
+	return wl12xx_acx_sleep_auth(wl, WL12XX_PSM_CAM);
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
new file mode 100644
index 0000000..c8b6cd0
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -0,0 +1,40 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_INIT_H__
+#define __WL12XX_INIT_H__
+
+#include "wl12xx.h"
+
+int wl12xx_hw_init_hwenc_config(struct wl12xx *wl);
+int wl12xx_hw_init_templates_config(struct wl12xx *wl);
+int wl12xx_hw_init_mem_config(struct wl12xx *wl);
+int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter);
+int wl12xx_hw_init_phy_config(struct wl12xx *wl);
+int wl12xx_hw_init_beacon_filter(struct wl12xx *wl);
+int wl12xx_hw_init_pta(struct wl12xx *wl);
+int wl12xx_hw_init_energy_detection(struct wl12xx *wl);
+int wl12xx_hw_init_beacon_broadcast(struct wl12xx *wl);
+int wl12xx_hw_init_power_auth(struct wl12xx *wl);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
new file mode 100644
index 0000000..16cd46c
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -0,0 +1,1442 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/spi/spi.h>
+#include <linux/crc32.h>
+#include <linux/etherdevice.h>
+#include <linux/spi/wl12xx.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "wl1251_ops.h"
+#include "wl1251_spi.h"
+#include "wl1251_event.h"
+#include "wl1251_tx.h"
+#include "wl1251_rx.h"
+#include "wl1251_ps.h"
+#include "wl1251_init.h"
+#include "wl1251_debugfs.h"
+
+static void wl12xx_disable_interrupts(struct wl12xx *wl)
+{
+	disable_irq(wl->irq);
+}
+
+static void wl12xx_power_off(struct wl12xx *wl)
+{
+	wl->set_power(false);
+}
+
+static void wl12xx_power_on(struct wl12xx *wl)
+{
+	wl->set_power(true);
+}
+
+static irqreturn_t wl12xx_irq(int irq, void *cookie)
+{
+	struct wl12xx *wl;
+
+	wl12xx_debug(DEBUG_IRQ, "IRQ");
+
+	wl = cookie;
+
+	schedule_work(&wl->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static int wl12xx_fetch_firmware(struct wl12xx *wl)
+{
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, wl->chip.fw_filename, &wl->spi->dev);
+
+	if (ret < 0) {
+		wl12xx_error("could not get firmware: %d", ret);
+		return ret;
+	}
+
+	if (fw->size % 4) {
+		wl12xx_error("firmware size is not multiple of 32 bits: %zu",
+			     fw->size);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	wl->fw_len = fw->size;
+	wl->fw = kmalloc(wl->fw_len, GFP_KERNEL);
+
+	if (!wl->fw) {
+		wl12xx_error("could not allocate memory for the firmware");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(wl->fw, fw->data, wl->fw_len);
+
+	ret = 0;
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int wl12xx_fetch_nvs(struct wl12xx *wl)
+{
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, wl->chip.nvs_filename, &wl->spi->dev);
+
+	if (ret < 0) {
+		wl12xx_error("could not get nvs file: %d", ret);
+		return ret;
+	}
+
+	if (fw->size % 4) {
+		wl12xx_error("nvs size is not multiple of 32 bits: %zu",
+			     fw->size);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	wl->nvs_len = fw->size;
+	wl->nvs = kmalloc(wl->nvs_len, GFP_KERNEL);
+
+	if (!wl->nvs) {
+		wl12xx_error("could not allocate memory for the nvs file");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(wl->nvs, fw->data, wl->nvs_len);
+
+	ret = 0;
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static void wl12xx_fw_wakeup(struct wl12xx *wl)
+{
+	u32 elp_reg;
+
+	elp_reg = ELPCTRL_WAKE_UP;
+	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
+	elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
+
+	if (!(elp_reg & ELPCTRL_WLAN_READY)) {
+		wl12xx_warning("WLAN not ready");
+	}
+}
+
+static int wl12xx_chip_wakeup(struct wl12xx *wl)
+{
+	int ret = 0;
+
+	wl12xx_power_on(wl);
+	msleep(wl->chip.power_on_sleep);
+	wl12xx_spi_reset(wl);
+	wl12xx_spi_init(wl);
+
+	/* We don't need a real memory partition here, because we only want
+	 * to use the registers at this point. */
+	wl12xx_set_partition(wl,
+			     0x00000000,
+			     0x00000000,
+			     REGISTERS_BASE,
+			     REGISTERS_DOWN_SIZE);
+
+	/* ELP module wake up */
+	wl12xx_fw_wakeup(wl);
+
+	/* whal_FwCtrl_BootSm() */
+
+	/* 0. read chip id from CHIP_ID */
+	wl->chip.id = wl12xx_reg_read32(wl, CHIP_ID_B);
+
+	/* 1. check if chip id is valid */
+
+	switch (wl->chip.id) {
+	case CHIP_ID_1251_PG12:
+		wl12xx_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG12)",
+			     wl->chip.id);
+
+		wl1251_setup(wl);
+
+		break;
+	case CHIP_ID_1251_PG10:
+	case CHIP_ID_1251_PG11:
+	default:
+		wl12xx_error("unsupported chip id: 0x%x", wl->chip.id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (wl->fw == NULL) {
+		ret = wl12xx_fetch_firmware(wl);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* No NVS from netlink, try to get it from the filesystem */
+	if (wl->nvs == NULL) {
+		ret = wl12xx_fetch_nvs(wl);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void wl12xx_filter_work(struct work_struct *work)
+{
+	struct wl12xx *wl =
+		container_of(work, struct wl12xx, filter_work);
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL12XX_STATE_OFF)
+		goto out;
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* FIXME: replace the magic numbers with proper definitions */
+	ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl12xx_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+int wl12xx_plt_start(struct wl12xx *wl)
+{
+	int ret;
+
+	wl12xx_notice("power up");
+
+	if (wl->state != WL12XX_STATE_OFF) {
+		wl12xx_error("cannot go into PLT state because not "
+			     "in off state: %d", wl->state);
+		return -EBUSY;
+	}
+
+	wl->state = WL12XX_STATE_PLT;
+
+	ret = wl12xx_chip_wakeup(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl->chip.op_boot(wl);
+	if (ret < 0)
+		return ret;
+
+	wl12xx_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
+
+	ret = wl->chip.op_plt_init(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl12xx_plt_stop(struct wl12xx *wl)
+{
+	wl12xx_notice("power down");
+
+	if (wl->state != WL12XX_STATE_PLT) {
+		wl12xx_error("cannot power down because not in PLT "
+			     "state: %d", wl->state);
+		return -EBUSY;
+	}
+
+	wl12xx_disable_interrupts(wl);
+	wl12xx_power_off(wl);
+
+	wl->state = WL12XX_STATE_OFF;
+
+	return 0;
+}
+
+
+static int wl12xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct wl12xx *wl = hw->priv;
+
+	skb_queue_tail(&wl->tx_queue, skb);
+
+	/*
+	 * The chip specific setup must run before the first TX packet -
+	 * before that, the tx_work will not be initialized!
+	 */
+
+	schedule_work(&wl->tx_work);
+
+	/*
+	 * The workqueue is slow to process the tx_queue and we need stop
+	 * the queue here, otherwise the queue will get too long.
+	 */
+	if (skb_queue_len(&wl->tx_queue) >= WL12XX_TX_QUEUE_MAX_LENGTH) {
+		ieee80211_stop_queues(wl->hw);
+
+		/*
+		 * FIXME: this is racy, the variable is not properly
+		 * protected. Maybe fix this by removing the stupid
+		 * variable altogether and checking the real queue state?
+		 */
+		wl->tx_queue_stopped = true;
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static int wl12xx_op_start(struct ieee80211_hw *hw)
+{
+	struct wl12xx *wl = hw->priv;
+	int ret = 0;
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 start");
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state != WL12XX_STATE_OFF) {
+		wl12xx_error("cannot start because not in off state: %d",
+			     wl->state);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = wl12xx_chip_wakeup(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl->chip.op_boot(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl->chip.op_hw_init(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_acx_station_id(wl);
+	if (ret < 0)
+		goto out;
+
+	wl->state = WL12XX_STATE_ON;
+
+	wl12xx_info("firmware booted (%s)", wl->chip.fw_ver);
+
+out:
+	if (ret < 0)
+		wl12xx_power_off(wl);
+
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static void wl12xx_op_stop(struct ieee80211_hw *hw)
+{
+	struct wl12xx *wl = hw->priv;
+
+	wl12xx_info("down");
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 stop");
+
+	mutex_lock(&wl->mutex);
+
+	WARN_ON(wl->state != WL12XX_STATE_ON);
+
+	if (wl->scanning) {
+		mutex_unlock(&wl->mutex);
+		ieee80211_scan_completed(wl->hw, true);
+		mutex_lock(&wl->mutex);
+		wl->scanning = false;
+	}
+
+	wl->state = WL12XX_STATE_OFF;
+
+	wl12xx_disable_interrupts(wl);
+
+	mutex_unlock(&wl->mutex);
+
+	cancel_work_sync(&wl->irq_work);
+	cancel_work_sync(&wl->tx_work);
+	cancel_work_sync(&wl->filter_work);
+
+	mutex_lock(&wl->mutex);
+
+	/* let's notify MAC80211 about the remaining pending TX frames */
+	wl->chip.op_tx_flush(wl);
+	wl12xx_power_off(wl);
+
+	memset(wl->bssid, 0, ETH_ALEN);
+	wl->listen_int = 1;
+	wl->bss_type = MAX_BSS_TYPE;
+
+	wl->data_in_count = 0;
+	wl->rx_counter = 0;
+	wl->rx_handled = 0;
+	wl->rx_current_buffer = 0;
+	wl->rx_last_id = 0;
+	wl->next_tx_complete = 0;
+	wl->elp = false;
+	wl->psm = 0;
+	wl->tx_queue_stopped = false;
+	wl->power_level = WL12XX_DEFAULT_POWER_LEVEL;
+
+	wl12xx_debugfs_reset(wl);
+
+	mutex_unlock(&wl->mutex);
+}
+
+static int wl12xx_op_add_interface(struct ieee80211_hw *hw,
+				   struct ieee80211_if_init_conf *conf)
+{
+	struct wl12xx *wl = hw->priv;
+	DECLARE_MAC_BUF(mac);
+	int ret = 0;
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
+		     conf->type, print_mac(mac, conf->mac_addr));
+
+	mutex_lock(&wl->mutex);
+
+	switch (conf->type) {
+	case NL80211_IFTYPE_STATION:
+		wl->bss_type = BSS_TYPE_STA_BSS;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		wl->bss_type = BSS_TYPE_IBSS;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (memcmp(wl->mac_addr, conf->mac_addr, ETH_ALEN)) {
+		memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+		SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+		ret = wl12xx_acx_station_id(wl);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+}
+
+static void wl12xx_op_remove_interface(struct ieee80211_hw *hw,
+					 struct ieee80211_if_init_conf *conf)
+{
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 remove interface");
+}
+
+static int wl12xx_build_null_data(struct wl12xx *wl)
+{
+	struct wl12xx_null_data_template template;
+
+	if (!is_zero_ether_addr(wl->bssid)) {
+		memcpy(template.header.da, wl->bssid, ETH_ALEN);
+		memcpy(template.header.bssid, wl->bssid, ETH_ALEN);
+	} else {
+		memset(template.header.da, 0xff, ETH_ALEN);
+		memset(template.header.bssid, 0xff, ETH_ALEN);
+	}
+
+	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
+	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
+						IEEE80211_STYPE_NULLFUNC);
+
+	return wl12xx_cmd_template_set(wl, CMD_NULL_DATA, &template,
+				       sizeof(template));
+
+}
+
+static int wl12xx_build_ps_poll(struct wl12xx *wl, u16 aid)
+{
+	struct wl12xx_ps_poll_template template;
+
+	memcpy(template.bssid, wl->bssid, ETH_ALEN);
+	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
+	template.aid = aid;
+	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
+
+	return wl12xx_cmd_template_set(wl, CMD_PS_POLL, &template,
+				       sizeof(template));
+
+}
+
+static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct wl12xx *wl = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	int channel, ret = 0;
+
+	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+		     channel,
+		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
+		     conf->power_level);
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	if (channel != wl->channel) {
+		/* FIXME: use beacon interval provided by mac80211 */
+		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		if (ret < 0)
+			goto out_sleep;
+
+		wl->channel = channel;
+	}
+
+	ret = wl12xx_build_null_data(wl);
+	if (ret < 0)
+		goto out_sleep;
+
+	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
+		wl12xx_info("psm enabled");
+
+		wl->psm_requested = true;
+
+		/*
+		 * We enter PSM only if we're already associated.
+		 * If we're not, we'll enter it when joining an SSID,
+		 * through the bss_info_changed() hook.
+		 */
+		ret = wl12xx_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
+		   wl->psm_requested) {
+		wl12xx_info("psm disabled");
+
+		wl->psm_requested = false;
+
+		if (wl->psm)
+			ret = wl12xx_ps_set_mode(wl, STATION_ACTIVE_MODE);
+	}
+
+	if (conf->power_level != wl->power_level) {
+		ret = wl12xx_acx_tx_power(wl, conf->power_level);
+		if (ret < 0)
+			goto out;
+
+		wl->power_level = conf->power_level;
+	}
+
+out_sleep:
+	wl12xx_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+#define WL12XX_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
+				  FIF_ALLMULTI | \
+				  FIF_FCSFAIL | \
+				  FIF_BCN_PRBRESP_PROMISC | \
+				  FIF_CONTROL | \
+				  FIF_OTHER_BSS)
+
+static void wl12xx_op_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed,
+				       unsigned int *total,
+				       int mc_count,
+				       struct dev_addr_list *mc_list)
+{
+	struct wl12xx *wl = hw->priv;
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 configure filter");
+
+	*total &= WL12XX_SUPPORTED_FILTERS;
+	changed &= WL12XX_SUPPORTED_FILTERS;
+
+	if (changed == 0)
+		/* no filters which we support changed */
+		return;
+
+	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
+
+	wl->rx_config = WL12XX_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL12XX_DEFAULT_RX_FILTER;
+
+	if (*total & FIF_PROMISC_IN_BSS) {
+		wl->rx_config |= CFG_BSSID_FILTER_EN;
+		wl->rx_config |= CFG_RX_ALL_GOOD;
+	}
+	if (*total & FIF_ALLMULTI)
+		/*
+		 * CFG_MC_FILTER_EN in rx_config needs to be 0 to receive
+		 * all multicast frames
+		 */
+		wl->rx_config &= ~CFG_MC_FILTER_EN;
+	if (*total & FIF_FCSFAIL)
+		wl->rx_filter |= CFG_RX_FCS_ERROR;
+	if (*total & FIF_BCN_PRBRESP_PROMISC) {
+		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+		wl->rx_config &= ~CFG_SSID_FILTER_EN;
+	}
+	if (*total & FIF_CONTROL)
+		wl->rx_filter |= CFG_RX_CTL_EN;
+	if (*total & FIF_OTHER_BSS)
+		wl->rx_filter &= ~CFG_BSSID_FILTER_EN;
+
+	/*
+	 * FIXME: workqueues need to be properly cancelled on stop(), for
+	 * now let's just disable changing the filter settings. They will
+	 * be updated any on config().
+	 */
+	/* schedule_work(&wl->filter_work); */
+}
+
+/* HW encryption */
+static int wl12xx_set_key_type(struct wl12xx *wl,
+			       struct wl12xx_cmd_set_keys *key,
+			       enum set_key_cmd cmd,
+			       struct ieee80211_key_conf *mac80211_key,
+			       const u8 *addr)
+{
+	switch (mac80211_key->alg) {
+	case ALG_WEP:
+		if (is_broadcast_ether_addr(addr))
+			key->key_type = KEY_WEP_DEFAULT;
+		else
+			key->key_type = KEY_WEP_ADDR;
+
+		mac80211_key->hw_key_idx = mac80211_key->keyidx;
+		break;
+	case ALG_TKIP:
+		if (is_broadcast_ether_addr(addr))
+			key->key_type = KEY_TKIP_MIC_GROUP;
+		else
+			key->key_type = KEY_TKIP_MIC_PAIRWISE;
+
+		mac80211_key->hw_key_idx = mac80211_key->keyidx;
+		break;
+	case ALG_CCMP:
+		if (is_broadcast_ether_addr(addr))
+			key->key_type = KEY_AES_GROUP;
+		else
+			key->key_type = KEY_AES_PAIRWISE;
+		mac80211_key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		break;
+	default:
+		wl12xx_error("Unknown key algo 0x%x", mac80211_key->alg);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta,
+			     struct ieee80211_key_conf *key)
+{
+	struct wl12xx *wl = hw->priv;
+	struct wl12xx_cmd_set_keys *wl_cmd;
+	const u8 *addr;
+	int ret;
+
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 set key");
+
+	wl_cmd = kzalloc(sizeof(*wl_cmd), GFP_KERNEL);
+	if (!wl_cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	addr = sta ? sta->addr : bcast_addr;
+
+	wl12xx_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
+	wl12xx_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
+	wl12xx_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
+		     key->alg, key->keyidx, key->keylen, key->flags);
+	wl12xx_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
+
+	if (is_zero_ether_addr(addr)) {
+		/* We dont support TX only encryption */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
+	switch (cmd) {
+	case SET_KEY:
+		wl_cmd->key_action = KEY_ADD_OR_REPLACE;
+		break;
+	case DISABLE_KEY:
+		wl_cmd->key_action = KEY_REMOVE;
+		break;
+	default:
+		wl12xx_error("Unsupported key cmd 0x%x", cmd);
+		break;
+	}
+
+	ret = wl12xx_set_key_type(wl, wl_cmd, cmd, key, addr);
+	if (ret < 0) {
+		wl12xx_error("Set KEY type failed");
+		goto out_sleep;
+	}
+
+	if (wl_cmd->key_type != KEY_WEP_DEFAULT)
+		memcpy(wl_cmd->addr, addr, ETH_ALEN);
+
+	if ((wl_cmd->key_type == KEY_TKIP_MIC_GROUP) ||
+	    (wl_cmd->key_type == KEY_TKIP_MIC_PAIRWISE)) {
+		/*
+		 * We get the key in the following form:
+		 * TKIP (16 bytes) - TX MIC (8 bytes) - RX MIC (8 bytes)
+		 * but the target is expecting:
+		 * TKIP - RX MIC - TX MIC
+		 */
+		memcpy(wl_cmd->key, key->key, 16);
+		memcpy(wl_cmd->key + 16, key->key + 24, 8);
+		memcpy(wl_cmd->key + 24, key->key + 16, 8);
+
+	} else {
+		memcpy(wl_cmd->key, key->key, key->keylen);
+	}
+	wl_cmd->key_size = key->keylen;
+
+	wl_cmd->id = key->keyidx;
+	wl_cmd->ssid_profile = 0;
+
+	wl12xx_dump(DEBUG_CRYPT, "TARGET KEY: ", wl_cmd, sizeof(*wl_cmd));
+
+	ret = wl12xx_cmd_send(wl, CMD_SET_KEYS, wl_cmd, sizeof(*wl_cmd));
+	if (ret < 0) {
+		wl12xx_warning("could not set keys");
+		goto out_sleep;
+	}
+
+out_sleep:
+	wl12xx_ps_elp_sleep(wl);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+out:
+	kfree(wl_cmd);
+
+	return ret;
+}
+
+static int wl12xx_build_basic_rates(char *rates)
+{
+	u8 index = 0;
+
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
+
+	return index;
+}
+
+static int wl12xx_build_extended_rates(char *rates)
+{
+	u8 index = 0;
+
+	rates[index++] = IEEE80211_OFDM_RATE_6MB;
+	rates[index++] = IEEE80211_OFDM_RATE_9MB;
+	rates[index++] = IEEE80211_OFDM_RATE_12MB;
+	rates[index++] = IEEE80211_OFDM_RATE_18MB;
+	rates[index++] = IEEE80211_OFDM_RATE_24MB;
+	rates[index++] = IEEE80211_OFDM_RATE_36MB;
+	rates[index++] = IEEE80211_OFDM_RATE_48MB;
+	rates[index++] = IEEE80211_OFDM_RATE_54MB;
+
+	return index;
+}
+
+
+static int wl12xx_build_probe_req(struct wl12xx *wl, u8 *ssid, size_t ssid_len)
+{
+	struct wl12xx_probe_req_template template;
+	struct wl12xx_ie_rates *rates;
+	char *ptr;
+	u16 size;
+
+	ptr = (char *)&template;
+	size = sizeof(struct ieee80211_header);
+
+	memset(template.header.da, 0xff, ETH_ALEN);
+	memset(template.header.bssid, 0xff, ETH_ALEN);
+	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
+	template.header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+
+	/* IEs */
+	/* SSID */
+	template.ssid.header.id = WLAN_EID_SSID;
+	template.ssid.header.len = ssid_len;
+	if (ssid_len && ssid)
+		memcpy(template.ssid.ssid, ssid, ssid_len);
+	size += sizeof(struct wl12xx_ie_header) + ssid_len;
+	ptr += size;
+
+	/* Basic Rates */
+	rates = (struct wl12xx_ie_rates *)ptr;
+	rates->header.id = WLAN_EID_SUPP_RATES;
+	rates->header.len = wl12xx_build_basic_rates(rates->rates);
+	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
+	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
+
+	/* Extended rates */
+	rates = (struct wl12xx_ie_rates *)ptr;
+	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
+	rates->header.len = wl12xx_build_extended_rates(rates->rates);
+	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
+
+	wl12xx_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
+
+	return wl12xx_cmd_template_set(wl, CMD_PROBE_REQ, &template,
+				      size);
+}
+
+static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
+			  u8 active_scan, u8 high_prio, u8 num_channels,
+			  u8 probe_requests)
+{
+	struct wl12xx_cmd_trigger_scan_to *trigger = NULL;
+	struct cmd_scan *params = NULL;
+	int i, ret;
+	u16 scan_options = 0;
+
+	if (wl->scanning)
+		return -EINVAL;
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	params->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
+	params->params.rx_filter_options =
+		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
+
+	/* High priority scan */
+	if (!active_scan)
+		scan_options |= SCAN_PASSIVE;
+	if (high_prio)
+		scan_options |= SCAN_PRIORITY_HIGH;
+	params->params.scan_options = scan_options;
+
+	params->params.num_channels = num_channels;
+	params->params.num_probe_requests = probe_requests;
+	params->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */
+	params->params.tid_trigger = 0;
+
+	for (i = 0; i < num_channels; i++) {
+		params->channels[i].min_duration = cpu_to_le32(30000);
+		params->channels[i].max_duration = cpu_to_le32(60000);
+		memset(&params->channels[i].bssid_lsb, 0xff, 4);
+		memset(&params->channels[i].bssid_msb, 0xff, 2);
+		params->channels[i].early_termination = 0;
+		params->channels[i].tx_power_att = 0;
+		params->channels[i].channel = i + 1;
+		memset(params->channels[i].pad, 0, 3);
+	}
+
+	for (i = num_channels; i < SCAN_MAX_NUM_OF_CHANNELS; i++)
+		memset(&params->channels[i], 0,
+		       sizeof(struct basic_scan_channel_parameters));
+
+	if (len && ssid) {
+		params->params.ssid_len = len;
+		memcpy(params->params.ssid, ssid, len);
+	} else {
+		params->params.ssid_len = 0;
+		memset(params->params.ssid, 0, 32);
+	}
+
+	ret = wl12xx_build_probe_req(wl, ssid, len);
+	if (ret < 0) {
+		wl12xx_error("PROBE request template failed");
+		goto out;
+	}
+
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!trigger)
+		goto out;
+
+	trigger->timeout = 0;
+
+	ret = wl12xx_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
+			      sizeof(*trigger));
+	if (ret < 0) {
+		wl12xx_error("trigger scan to failed for hw scan");
+		goto out;
+	}
+
+	wl12xx_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
+
+	wl->scanning = true;
+
+	ret = wl12xx_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
+	if (ret < 0)
+		wl12xx_error("SCAN failed");
+
+	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+
+	if (params->header.status != CMD_STATUS_SUCCESS) {
+		wl12xx_error("TEST command answer error: %d",
+			     params->header.status);
+		wl->scanning = false;
+		ret = -EIO;
+		goto out;
+	}
+
+out:
+	kfree(params);
+	return ret;
+
+}
+
+static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
+			     struct cfg80211_scan_request *req)
+{
+	struct wl12xx *wl = hw->priv;
+	int ret;
+	u8 *ssid = NULL;
+	size_t ssid_len = 0;
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 hw scan");
+
+	if (req->n_ssids) {
+		ssid = req->ssids[0].ssid;
+		ssid_len = req->ssids[0].ssid_len;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
+
+	wl12xx_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static int wl12xx_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	struct wl12xx *wl = hw->priv;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_acx_rts_threshold(wl, (u16) value);
+	if (ret < 0)
+		wl12xx_warning("wl12xx_op_set_rts_threshold failed: %d", ret);
+
+	wl12xx_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *bss_conf,
+				       u32 changed)
+{
+	enum wl12xx_cmd_ps_mode mode;
+	struct wl12xx *wl = hw->priv;
+	struct sk_buff *beacon;
+	int ret;
+
+	wl12xx_debug(DEBUG_MAC80211, "mac80211 bss info changed");
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl12xx_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		if (bss_conf->assoc) {
+			wl->aid = bss_conf->aid;
+
+			ret = wl12xx_build_ps_poll(wl, wl->aid);
+			if (ret < 0)
+				goto out_sleep;
+
+			ret = wl12xx_acx_aid(wl, wl->aid);
+			if (ret < 0)
+				goto out_sleep;
+
+			/* If we want to go in PSM but we're not there yet */
+			if (wl->psm_requested && !wl->psm) {
+				mode = STATION_POWER_SAVE_MODE;
+				ret = wl12xx_ps_set_mode(wl, mode);
+				if (ret < 0)
+					goto out_sleep;
+			}
+		}
+	}
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (bss_conf->use_short_slot)
+			ret = wl12xx_acx_slot(wl, SLOT_TIME_SHORT);
+		else
+			ret = wl12xx_acx_slot(wl, SLOT_TIME_LONG);
+		if (ret < 0) {
+			wl12xx_warning("Set slot time failed %d", ret);
+			goto out_sleep;
+		}
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		if (bss_conf->use_short_preamble)
+			wl12xx_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
+		else
+			wl12xx_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
+	}
+
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		if (bss_conf->use_cts_prot)
+			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_ENABLE);
+		else
+			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_DISABLE);
+		if (ret < 0) {
+			wl12xx_warning("Set ctsprotect failed %d", ret);
+			goto out_sleep;
+		}
+	}
+
+	if (changed & BSS_CHANGED_BSSID) {
+		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+
+		ret = wl12xx_build_null_data(wl);
+		if (ret < 0)
+			goto out;
+
+		if (wl->bss_type != BSS_TYPE_IBSS) {
+			ret = wl->chip.op_cmd_join(wl, wl->bss_type, 5, 100, 1);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
+	if (changed & BSS_CHANGED_BEACON) {
+		beacon = ieee80211_beacon_get(hw, vif);
+		ret = wl12xx_cmd_template_set(wl, CMD_BEACON, beacon->data,
+					      beacon->len);
+
+		if (ret < 0) {
+			dev_kfree_skb(beacon);
+			goto out;
+		}
+
+		ret = wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
+					      beacon->len);
+
+		dev_kfree_skb(beacon);
+
+		if (ret < 0)
+			goto out;
+
+		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
+
+		if (ret < 0)
+			goto out;
+	}
+
+out_sleep:
+	wl12xx_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+
+/* can't be const, mac80211 writes to this */
+static struct ieee80211_rate wl12xx_rates[] = {
+	{ .bitrate = 10,
+	  .hw_value = 0x1,
+	  .hw_value_short = 0x1, },
+	{ .bitrate = 20,
+	  .hw_value = 0x2,
+	  .hw_value_short = 0x2,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+	  .hw_value = 0x4,
+	  .hw_value_short = 0x4,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+	  .hw_value = 0x20,
+	  .hw_value_short = 0x20,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60,
+	  .hw_value = 0x8,
+	  .hw_value_short = 0x8, },
+	{ .bitrate = 90,
+	  .hw_value = 0x10,
+	  .hw_value_short = 0x10, },
+	{ .bitrate = 120,
+	  .hw_value = 0x40,
+	  .hw_value_short = 0x40, },
+	{ .bitrate = 180,
+	  .hw_value = 0x80,
+	  .hw_value_short = 0x80, },
+	{ .bitrate = 240,
+	  .hw_value = 0x200,
+	  .hw_value_short = 0x200, },
+	{ .bitrate = 360,
+	 .hw_value = 0x400,
+	 .hw_value_short = 0x400, },
+	{ .bitrate = 480,
+	  .hw_value = 0x800,
+	  .hw_value_short = 0x800, },
+	{ .bitrate = 540,
+	  .hw_value = 0x1000,
+	  .hw_value_short = 0x1000, },
+};
+
+/* can't be const, mac80211 writes to this */
+static struct ieee80211_channel wl12xx_channels[] = {
+	{ .hw_value = 1, .center_freq = 2412},
+	{ .hw_value = 2, .center_freq = 2417},
+	{ .hw_value = 3, .center_freq = 2422},
+	{ .hw_value = 4, .center_freq = 2427},
+	{ .hw_value = 5, .center_freq = 2432},
+	{ .hw_value = 6, .center_freq = 2437},
+	{ .hw_value = 7, .center_freq = 2442},
+	{ .hw_value = 8, .center_freq = 2447},
+	{ .hw_value = 9, .center_freq = 2452},
+	{ .hw_value = 10, .center_freq = 2457},
+	{ .hw_value = 11, .center_freq = 2462},
+	{ .hw_value = 12, .center_freq = 2467},
+	{ .hw_value = 13, .center_freq = 2472},
+};
+
+/* can't be const, mac80211 writes to this */
+static struct ieee80211_supported_band wl12xx_band_2ghz = {
+	.channels = wl12xx_channels,
+	.n_channels = ARRAY_SIZE(wl12xx_channels),
+	.bitrates = wl12xx_rates,
+	.n_bitrates = ARRAY_SIZE(wl12xx_rates),
+};
+
+static const struct ieee80211_ops wl12xx_ops = {
+	.start = wl12xx_op_start,
+	.stop = wl12xx_op_stop,
+	.add_interface = wl12xx_op_add_interface,
+	.remove_interface = wl12xx_op_remove_interface,
+	.config = wl12xx_op_config,
+	.configure_filter = wl12xx_op_configure_filter,
+	.tx = wl12xx_op_tx,
+	.set_key = wl12xx_op_set_key,
+	.hw_scan = wl12xx_op_hw_scan,
+	.bss_info_changed = wl12xx_op_bss_info_changed,
+	.set_rts_threshold = wl12xx_op_set_rts_threshold,
+};
+
+static int wl12xx_register_hw(struct wl12xx *wl)
+{
+	int ret;
+
+	if (wl->mac80211_registered)
+		return 0;
+
+	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+
+	ret = ieee80211_register_hw(wl->hw);
+	if (ret < 0) {
+		wl12xx_error("unable to register mac80211 hw: %d", ret);
+		return ret;
+	}
+
+	wl->mac80211_registered = true;
+
+	wl12xx_notice("loaded");
+
+	return 0;
+}
+
+static int wl12xx_init_ieee80211(struct wl12xx *wl)
+{
+	/* The tx descriptor buffer and the TKIP space */
+	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
+		+ WL1251_TKIP_IV_SPACE;
+
+	/* unit us */
+	/* FIXME: find a proper value */
+	wl->hw->channel_change_time = 10000;
+
+	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_NOISE_DBM;
+
+	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wl->hw->wiphy->max_scan_ssids = 1;
+	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
+
+	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
+
+	return 0;
+}
+
+#define WL12XX_DEFAULT_CHANNEL 1
+static int __devinit wl12xx_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl12xx *wl;
+	int ret, i;
+	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl12xx_error("no platform data");
+		return -ENODEV;
+	}
+
+	hw = ieee80211_alloc_hw(sizeof(*wl), &wl12xx_ops);
+	if (!hw) {
+		wl12xx_error("could not alloc ieee80211_hw");
+		return -ENOMEM;
+	}
+
+	wl = hw->priv;
+	memset(wl, 0, sizeof(*wl));
+
+	wl->hw = hw;
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+
+	wl->data_in_count = 0;
+
+	skb_queue_head_init(&wl->tx_queue);
+
+	INIT_WORK(&wl->filter_work, wl12xx_filter_work);
+	wl->channel = WL12XX_DEFAULT_CHANNEL;
+	wl->scanning = false;
+	wl->default_key = 0;
+	wl->listen_int = 1;
+	wl->rx_counter = 0;
+	wl->rx_handled = 0;
+	wl->rx_current_buffer = 0;
+	wl->rx_last_id = 0;
+	wl->rx_config = WL12XX_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL12XX_DEFAULT_RX_FILTER;
+	wl->elp = false;
+	wl->psm = 0;
+	wl->psm_requested = false;
+	wl->tx_queue_stopped = false;
+	wl->power_level = WL12XX_DEFAULT_POWER_LEVEL;
+
+	/* We use the default power on sleep time until we know which chip
+	 * we're using */
+	wl->chip.power_on_sleep = WL12XX_DEFAULT_POWER_ON_SLEEP;
+
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+		wl->tx_frames[i] = NULL;
+
+	wl->next_tx_complete = 0;
+
+	/*
+	 * In case our MAC address is not correctly set,
+	 * we use a random but Nokia MAC.
+	 */
+	memcpy(wl->mac_addr, nokia_oui, 3);
+	get_random_bytes(wl->mac_addr + 3, 3);
+
+	wl->state = WL12XX_STATE_OFF;
+	mutex_init(&wl->mutex);
+
+	wl->tx_mgmt_frm_rate = DEFAULT_HW_GEN_TX_RATE;
+	wl->tx_mgmt_frm_mod = DEFAULT_HW_GEN_MODULATION_TYPE;
+
+	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
+	if (!wl->rx_descriptor) {
+		wl12xx_error("could not allocate memory for rx descriptor");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	/* This is the only SPI value that we need to set here, the rest
+	 * comes from the board-peripherals file */
+	spi->bits_per_word = 32;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		wl12xx_error("spi_setup failed");
+		goto out_free;
+	}
+
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl12xx_error("set power function missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	wl->irq = spi->irq;
+	if (wl->irq < 0) {
+		wl12xx_error("irq missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
+	if (ret < 0) {
+		wl12xx_error("request_irq() failed: %d", ret);
+		goto out_free;
+	}
+
+	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(wl->irq);
+
+	ret = wl12xx_init_ieee80211(wl);
+	if (ret)
+		goto out_irq;
+
+	ret = wl12xx_register_hw(wl);
+	if (ret)
+		goto out_irq;
+
+	wl12xx_debugfs_init(wl);
+
+	wl12xx_notice("initialized");
+
+	return 0;
+
+ out_irq:
+	free_irq(wl->irq, wl);
+
+ out_free:
+	kfree(wl->rx_descriptor);
+	wl->rx_descriptor = NULL;
+
+	ieee80211_free_hw(hw);
+
+	return ret;
+}
+
+static int __devexit wl12xx_remove(struct spi_device *spi)
+{
+	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
+
+	ieee80211_unregister_hw(wl->hw);
+
+	wl12xx_debugfs_exit(wl);
+
+	free_irq(wl->irq, wl);
+	kfree(wl->target_mem_map);
+	kfree(wl->data_path);
+	kfree(wl->fw);
+	wl->fw = NULL;
+	kfree(wl->nvs);
+	wl->nvs = NULL;
+
+	kfree(wl->rx_descriptor);
+	wl->rx_descriptor = NULL;
+
+	ieee80211_free_hw(wl->hw);
+
+	return 0;
+}
+
+
+static struct spi_driver wl12xx_spi_driver = {
+	.driver = {
+		.name		= "wl12xx",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= wl12xx_probe,
+	.remove		= __devexit_p(wl12xx_remove),
+};
+
+static int __init wl12xx_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&wl12xx_spi_driver);
+	if (ret < 0) {
+		wl12xx_error("failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wl12xx_exit(void)
+{
+	spi_unregister_driver(&wl12xx_spi_driver);
+
+	wl12xx_notice("unloaded");
+}
+
+module_init(wl12xx_init);
+module_exit(wl12xx_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
+		"Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_netlink.c b/drivers/net/wireless/wl12xx/wl1251_netlink.c
new file mode 100644
index 0000000..1bc049f
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_netlink.c
@@ -0,0 +1,679 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#include "wl1251_netlink.h"
+
+#include <linux/mutex.h>
+#include <linux/socket.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/wireless.h>
+#include <net/mac80211.h>
+
+#include "wl12xx.h"
+#include "wl1251_spi.h"
+#include "wl1251_acx.h"
+
+/* FIXME: this should be changed as soon as user space catches up */
+#define WL12XX_NL_NAME "wl1251"
+#define WL12XX_NL_VERSION 1
+
+#define WL12XX_MAX_TEST_LENGTH 1024
+#define WL12XX_MAX_NVS_LENGTH 1024
+
+enum wl12xx_nl_commands {
+	WL12XX_NL_CMD_UNSPEC,
+	WL12XX_NL_CMD_TEST,
+	WL12XX_NL_CMD_INTERROGATE,
+	WL12XX_NL_CMD_CONFIGURE,
+	WL12XX_NL_CMD_PHY_REG_READ,
+	WL12XX_NL_CMD_NVS_PUSH,
+	WL12XX_NL_CMD_REG_WRITE,
+	WL12XX_NL_CMD_REG_READ,
+	WL12XX_NL_CMD_SET_PLT_MODE,
+
+	__WL12XX_NL_CMD_AFTER_LAST
+};
+#define WL12XX_NL_CMD_MAX (__WL12XX_NL_CMD_AFTER_LAST - 1)
+
+enum wl12xx_nl_attrs {
+	WL12XX_NL_ATTR_UNSPEC,
+	WL12XX_NL_ATTR_IFNAME,
+	WL12XX_NL_ATTR_CMD_TEST_PARAM,
+	WL12XX_NL_ATTR_CMD_TEST_ANSWER,
+	WL12XX_NL_ATTR_CMD_IE,
+	WL12XX_NL_ATTR_CMD_IE_LEN,
+	WL12XX_NL_ATTR_CMD_IE_BUFFER,
+	WL12XX_NL_ATTR_CMD_IE_ANSWER,
+	WL12XX_NL_ATTR_REG_ADDR,
+	WL12XX_NL_ATTR_REG_VAL,
+	WL12XX_NL_ATTR_NVS_BUFFER,
+	WL12XX_NL_ATTR_NVS_LEN,
+	WL12XX_NL_ATTR_PLT_MODE,
+
+	__WL12XX_NL_ATTR_AFTER_LAST
+};
+#define WL12XX_NL_ATTR_MAX (__WL12XX_NL_ATTR_AFTER_LAST - 1)
+
+static struct genl_family wl12xx_nl_family = {
+	.id = GENL_ID_GENERATE,
+	.name = WL12XX_NL_NAME,
+	.hdrsize = 0,
+	.version = WL12XX_NL_VERSION,
+	.maxattr = WL12XX_NL_ATTR_MAX,
+};
+
+static struct net_device *ifname_to_netdev(struct net *net,
+					   struct genl_info *info)
+{
+	char *ifname;
+
+	if (!info->attrs[WL12XX_NL_ATTR_IFNAME])
+		return NULL;
+
+	ifname = nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]);
+
+	wl12xx_debug(DEBUG_NETLINK, "Looking for %s", ifname);
+
+	return dev_get_by_name(net, ifname);
+}
+
+static struct wl12xx *ifname_to_wl12xx(struct net *net, struct genl_info *info)
+{
+	struct net_device *netdev;
+	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
+	struct ieee80211_hw *hw;
+
+	netdev = ifname_to_netdev(net, info);
+	if (netdev == NULL) {
+		wl12xx_error("Wrong interface");
+		return NULL;
+	}
+
+	wdev = netdev->ieee80211_ptr;
+	if (wdev == NULL) {
+		wl12xx_error("ieee80211_ptr is NULL");
+		return NULL;
+	}
+
+	wiphy = wdev->wiphy;
+	if (wiphy == NULL) {
+		wl12xx_error("wiphy is NULL");
+		return NULL;
+	}
+
+	hw = wiphy_priv(wiphy);
+	if (hw == NULL) {
+		wl12xx_error("hw is NULL");
+		return NULL;
+	}
+
+	dev_put(netdev);
+
+	return hw->priv;
+}
+
+static int wl12xx_nl_test_cmd(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	struct wl12xx_command *cmd;
+	char *buf;
+	int buf_len, ret, cmd_len;
+	u8 answer;
+
+	if (!info->attrs[WL12XX_NL_ATTR_CMD_TEST_PARAM])
+		return -EINVAL;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		return -EINVAL;
+	}
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	buf = nla_data(info->attrs[WL12XX_NL_ATTR_CMD_TEST_PARAM]);
+	buf_len = nla_len(info->attrs[WL12XX_NL_ATTR_CMD_TEST_PARAM]);
+	answer = nla_get_u8(info->attrs[WL12XX_NL_ATTR_CMD_TEST_ANSWER]);
+
+	cmd->header.id = CMD_TEST;
+	memcpy(cmd->parameters, buf, buf_len);
+	cmd_len = sizeof(struct wl12xx_cmd_header) + buf_len;
+
+	mutex_lock(&wl->mutex);
+	ret = wl12xx_cmd_test(wl, cmd, cmd_len, answer);
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto out;
+	}
+
+	if (answer) {
+		struct sk_buff *msg;
+		void *hdr;
+
+		msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+		if (!msg) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
+				  &wl12xx_nl_family, 0, WL12XX_NL_CMD_TEST);
+		if (IS_ERR(hdr)) {
+			ret = PTR_ERR(hdr);
+			goto nla_put_failure;
+		}
+
+		NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
+			       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
+		NLA_PUT(msg, WL12XX_NL_ATTR_CMD_TEST_ANSWER,
+			sizeof(*cmd), cmd);
+
+		ret = genlmsg_end(msg, hdr);
+		if (ret < 0) {
+			wl12xx_error("%s() failed", __func__);
+			goto nla_put_failure;
+		}
+
+		wl12xx_debug(DEBUG_NETLINK, "TEST cmd sent, answer");
+		ret = genlmsg_reply(msg, info);
+		goto out;
+
+ nla_put_failure:
+		nlmsg_free(msg);
+	} else
+		wl12xx_debug(DEBUG_NETLINK, "TEST cmd sent");
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
+static int wl12xx_nl_interrogate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	struct sk_buff *msg;
+	int ret = -ENOBUFS, cmd_ie, cmd_ie_len;
+	struct wl12xx_command *cmd;
+	void *hdr;
+
+	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE])
+		return -EINVAL;
+
+	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN])
+		return -EINVAL;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		ret = -EINVAL;
+		goto nla_put_failure;
+	}
+
+	/* acx id */
+	cmd_ie = nla_get_u32(info->attrs[WL12XX_NL_ATTR_CMD_IE]);
+
+	/* maximum length of acx, including all headers */
+	cmd_ie_len = nla_get_u32(info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN]);
+
+	wl12xx_debug(DEBUG_NETLINK, "Getting IE 0x%x (len %d)",
+		     cmd_ie, cmd_ie_len);
+
+	mutex_lock(&wl->mutex);
+	ret = wl12xx_cmd_interrogate(wl, cmd_ie, cmd, cmd_ie_len);
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto nla_put_failure;
+	}
+
+	hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
+			  &wl12xx_nl_family, 0, WL12XX_NL_CMD_INTERROGATE);
+	if (IS_ERR(hdr)) {
+		ret = PTR_ERR(hdr);
+		goto nla_put_failure;
+	}
+
+	NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
+		       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
+	NLA_PUT(msg, WL12XX_NL_ATTR_CMD_IE_ANSWER, cmd_ie_len, cmd);
+
+	ret = genlmsg_end(msg, hdr);
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto nla_put_failure;
+	}
+
+	kfree(cmd);
+	return genlmsg_reply(msg, info);
+
+ nla_put_failure:
+	kfree(cmd);
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+static int wl12xx_nl_configure(struct sk_buff *skb, struct genl_info *info)
+{
+	int ret = 0, cmd_ie_len, acx_len;
+	struct acx_header *acx = NULL;
+	struct sk_buff *msg;
+	struct wl12xx *wl;
+	void *cmd_ie;
+	u16 *id;
+
+	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE_BUFFER])
+		return -EINVAL;
+
+	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN])
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		ret = -EINVAL;
+		goto nla_put_failure;
+	}
+
+	/* contains the acx header but not the cmd header */
+	cmd_ie = nla_data(info->attrs[WL12XX_NL_ATTR_CMD_IE_BUFFER]);
+
+	cmd_ie_len = nla_get_u32(info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN]);
+
+	/* acx id is in the first two bytes */
+	id = cmd_ie;
+
+	/* need to add acx_header before cmd_ie, so create a new command */
+	acx_len = sizeof(struct acx_header) + cmd_ie_len;
+	acx = kzalloc(acx_len, GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto nla_put_failure;
+	}
+
+	/* copy the acx header and the payload */
+	memcpy(&acx->id, cmd_ie, cmd_ie_len);
+
+	mutex_lock(&wl->mutex);
+	ret = wl12xx_cmd_configure(wl, *id, acx, acx_len);
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto nla_put_failure;
+	}
+
+	wl12xx_debug(DEBUG_NETLINK, "CONFIGURE cmd sent");
+
+ nla_put_failure:
+	kfree(acx);
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+static int wl12xx_nl_phy_reg_read(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	struct sk_buff *msg;
+	u32 reg_addr, *reg_value = NULL;
+	int ret = 0;
+	void *hdr;
+
+	if (!info->attrs[WL12XX_NL_ATTR_REG_ADDR])
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		ret = -EINVAL;
+		goto nla_put_failure;
+	}
+
+	reg_value = kmalloc(sizeof(*reg_value), GFP_KERNEL);
+	if (!reg_value) {
+		ret = -ENOMEM;
+		goto nla_put_failure;
+	}
+
+	reg_addr = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_ADDR]);
+
+	wl12xx_debug(DEBUG_NETLINK, "Reading PHY reg 0x%x", reg_addr);
+
+	mutex_lock(&wl->mutex);
+	ret = wl12xx_cmd_read_memory(wl, reg_addr, reg_value,
+				     sizeof(*reg_value));
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto nla_put_failure;
+	}
+
+
+	hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
+			  &wl12xx_nl_family, 0, WL12XX_NL_CMD_PHY_REG_READ);
+	if (IS_ERR(hdr)) {
+		ret = PTR_ERR(hdr);
+		goto nla_put_failure;
+	}
+
+	NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
+		       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
+
+	NLA_PUT_U32(msg, WL12XX_NL_ATTR_REG_VAL, *reg_value);
+
+	ret = genlmsg_end(msg, hdr);
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto nla_put_failure;
+	}
+
+	kfree(reg_value);
+
+	return genlmsg_reply(msg, info);
+
+ nla_put_failure:
+	nlmsg_free(msg);
+	kfree(reg_value);
+
+	return ret;
+}
+
+static int wl12xx_nl_nvs_push(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	int ret = 0;
+
+	if (!info->attrs[WL12XX_NL_ATTR_NVS_BUFFER])
+		return -EINVAL;
+
+	if (!info->attrs[WL12XX_NL_ATTR_NVS_LEN])
+		return -EINVAL;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+	wl->nvs_len = nla_get_u32(info->attrs[WL12XX_NL_ATTR_NVS_LEN]);
+	if (wl->nvs_len % 4) {
+		wl12xx_error("NVS size is not multiple of 32: %d", wl->nvs_len);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	/* If we already have an NVS, we should free it */
+	kfree(wl->nvs);
+
+	wl->nvs = kzalloc(wl->nvs_len, GFP_KERNEL);
+	if (wl->nvs == NULL) {
+		wl12xx_error("Can't allocate NVS");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(wl->nvs,
+	       nla_data(info->attrs[WL12XX_NL_ATTR_NVS_BUFFER]),
+	       wl->nvs_len);
+
+	wl12xx_debug(DEBUG_NETLINK, "got NVS from userspace, %d bytes",
+		     wl->nvs_len);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static int wl12xx_nl_reg_read(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	u32 addr, val;
+	int ret = 0;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (!info->attrs[WL12XX_NL_ATTR_REG_ADDR])
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		return -EINVAL;
+	}
+
+	addr = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_ADDR]);
+
+	mutex_lock(&wl->mutex);
+	val = wl12xx_reg_read32(wl, addr);
+	mutex_unlock(&wl->mutex);
+
+	hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
+			  &wl12xx_nl_family, 0, WL12XX_NL_CMD_PHY_REG_READ);
+	if (IS_ERR(hdr)) {
+		ret = PTR_ERR(hdr);
+		goto nla_put_failure;
+	}
+
+	NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
+		       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
+
+	NLA_PUT_U32(msg, WL12XX_NL_ATTR_REG_VAL, val);
+
+	ret = genlmsg_end(msg, hdr);
+	if (ret < 0) {
+		wl12xx_error("%s() failed", __func__);
+		goto nla_put_failure;
+	}
+
+	return genlmsg_reply(msg, info);
+
+ nla_put_failure:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+static int wl12xx_nl_reg_write(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	u32 addr, val;
+
+	if (!info->attrs[WL12XX_NL_ATTR_REG_ADDR])
+		return -EINVAL;
+
+	if (!info->attrs[WL12XX_NL_ATTR_REG_VAL])
+		return -EINVAL;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		return -EINVAL;
+	}
+
+	addr = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_ADDR]);
+	val = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_VAL]);
+
+	mutex_lock(&wl->mutex);
+	wl12xx_reg_write32(wl, addr, val);
+	mutex_unlock(&wl->mutex);
+
+	return 0;
+}
+
+static int wl12xx_nl_set_plt_mode(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wl12xx *wl;
+	u32 val;
+	int ret;
+
+	if (!info->attrs[WL12XX_NL_ATTR_PLT_MODE])
+		return -EINVAL;
+
+	wl = ifname_to_wl12xx(&init_net, info);
+	if (wl == NULL) {
+		wl12xx_error("wl12xx not found");
+		return -EINVAL;
+	}
+
+	val = nla_get_u32(info->attrs[WL12XX_NL_ATTR_PLT_MODE]);
+
+	switch (val) {
+	case 0:
+		ret = wl12xx_plt_stop(wl);
+		break;
+	case 1:
+		ret = wl12xx_plt_start(wl);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static struct nla_policy wl12xx_nl_policy[WL12XX_NL_ATTR_MAX + 1] = {
+	[WL12XX_NL_ATTR_IFNAME] =            { .type = NLA_NUL_STRING,
+					       .len = IFNAMSIZ-1 },
+	[WL12XX_NL_ATTR_CMD_TEST_PARAM] =    { .type = NLA_BINARY,
+					       .len = WL12XX_MAX_TEST_LENGTH },
+	[WL12XX_NL_ATTR_CMD_TEST_ANSWER] =   { .type = NLA_U8 },
+	[WL12XX_NL_ATTR_CMD_IE] =            { .type = NLA_U32 },
+	[WL12XX_NL_ATTR_CMD_IE_LEN] =        { .type = NLA_U32 },
+	[WL12XX_NL_ATTR_CMD_IE_BUFFER] =     { .type = NLA_BINARY,
+					       .len = WL12XX_MAX_TEST_LENGTH },
+	[WL12XX_NL_ATTR_CMD_IE_ANSWER] =     { .type = NLA_BINARY,
+					       .len = WL12XX_MAX_TEST_LENGTH },
+	[WL12XX_NL_ATTR_REG_ADDR] =          { .type = NLA_U32 },
+	[WL12XX_NL_ATTR_REG_VAL] =           { .type = NLA_U32 },
+	[WL12XX_NL_ATTR_NVS_BUFFER] =        { .type = NLA_BINARY,
+					       .len = WL12XX_MAX_NVS_LENGTH },
+	[WL12XX_NL_ATTR_NVS_LEN] =           { .type = NLA_U32 },
+	[WL12XX_NL_ATTR_PLT_MODE] =          { .type = NLA_U32 },
+};
+
+static struct genl_ops wl12xx_nl_ops[] = {
+	{
+		.cmd = WL12XX_NL_CMD_TEST,
+		.doit = wl12xx_nl_test_cmd,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_INTERROGATE,
+		.doit = wl12xx_nl_interrogate,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_CONFIGURE,
+		.doit = wl12xx_nl_configure,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_PHY_REG_READ,
+		.doit = wl12xx_nl_phy_reg_read,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_NVS_PUSH,
+		.doit = wl12xx_nl_nvs_push,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_REG_WRITE,
+		.doit = wl12xx_nl_reg_write,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_REG_READ,
+		.doit = wl12xx_nl_reg_read,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = WL12XX_NL_CMD_SET_PLT_MODE,
+		.doit = wl12xx_nl_set_plt_mode,
+		.policy = wl12xx_nl_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+};
+
+int wl12xx_nl_register(void)
+{
+	int err, i;
+
+	err = genl_register_family(&wl12xx_nl_family);
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(wl12xx_nl_ops); i++) {
+		err = genl_register_ops(&wl12xx_nl_family, &wl12xx_nl_ops[i]);
+		if (err)
+			goto err_out;
+	}
+	return 0;
+ err_out:
+	genl_unregister_family(&wl12xx_nl_family);
+	return err;
+}
+
+void wl12xx_nl_unregister(void)
+{
+	genl_unregister_family(&wl12xx_nl_family);
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_netlink.h b/drivers/net/wireless/wl12xx/wl1251_netlink.h
new file mode 100644
index 0000000..acfbd02
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_netlink.h
@@ -0,0 +1,30 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_NETLINK_H__
+#define __WL12XX_NETLINK_H__
+
+int wl12xx_nl_register(void);
+void wl12xx_nl_unregister(void);
+
+#endif /* __WL12XX_NETLINK_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.c b/drivers/net/wireless/wl12xx/wl1251_ops.c
index 126537f..cdfd2c2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.c
@@ -26,14 +26,14 @@
 
 #include "wl1251_ops.h"
 #include "reg.h"
-#include "spi.h"
-#include "boot.h"
-#include "event.h"
-#include "acx.h"
+#include "wl1251_spi.h"
+#include "wl1251_boot.h"
+#include "wl1251_event.h"
+#include "wl1251_acx.h"
 #include "wl1251_tx.h"
-#include "rx.h"
-#include "ps.h"
-#include "init.h"
+#include "wl1251_rx.h"
+#include "wl1251_ps.h"
+#include "wl1251_init.h"
 
 static struct wl12xx_partition_set wl1251_part_table[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.h b/drivers/net/wireless/wl12xx/wl1251_ops.h
index 74acf8e..7a78cc9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.h
@@ -27,7 +27,7 @@
 #include <linux/bitops.h>
 
 #include "wl12xx.h"
-#include "acx.h"
+#include "wl1251_acx.h"
 
 #define WL1251_FW_NAME "wl1251-fw.bin"
 #define WL1251_NVS_NAME "wl1251-nvs.bin"
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
new file mode 100644
index 0000000..83baaa2
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -0,0 +1,147 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "reg.h"
+#include "wl1251_ps.h"
+#include "wl1251_spi.h"
+
+#define WL12XX_WAKEUP_TIMEOUT 2000
+
+/* Routines to toggle sleep mode while in ELP */
+void wl12xx_ps_elp_sleep(struct wl12xx *wl)
+{
+	if (wl->elp || !wl->psm)
+		return;
+
+	wl12xx_debug(DEBUG_PSM, "chip to elp");
+
+	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
+
+	wl->elp = true;
+}
+
+int wl12xx_ps_elp_wakeup(struct wl12xx *wl)
+{
+	unsigned long timeout;
+	u32 elp_reg;
+
+	if (!wl->elp)
+		return 0;
+
+	wl12xx_debug(DEBUG_PSM, "waking up chip from elp");
+
+	timeout = jiffies + msecs_to_jiffies(WL12XX_WAKEUP_TIMEOUT);
+
+	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
+
+	elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
+
+	/*
+	 * FIXME: we should wait for irq from chip but, as a temporary
+	 * solution to simplify locking, let's poll instead
+	 */
+	while (!(elp_reg & ELPCTRL_WLAN_READY)) {
+		if (time_after(jiffies, timeout)) {
+			wl12xx_error("elp wakeup timeout");
+			return -ETIMEDOUT;
+		}
+		msleep(1);
+		elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
+	}
+
+	wl12xx_debug(DEBUG_PSM, "wakeup time: %u ms",
+		     jiffies_to_msecs(jiffies) -
+		     (jiffies_to_msecs(timeout) - WL12XX_WAKEUP_TIMEOUT));
+
+	wl->elp = false;
+
+	return 0;
+}
+
+static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
+{
+	int ret;
+
+	if (enable) {
+		wl12xx_debug(DEBUG_PSM, "sleep auth psm/elp");
+
+		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_ELP);
+		if (ret < 0)
+			return ret;
+
+		wl12xx_ps_elp_sleep(wl);
+	} else {
+		wl12xx_debug(DEBUG_PSM, "sleep auth cam");
+
+		/*
+		 * When the target is in ELP, we can only
+		 * access the ELP control register. Thus,
+		 * we have to wake the target up before
+		 * changing the power authorization.
+		 */
+
+		wl12xx_ps_elp_wakeup(wl);
+
+		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_CAM);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode)
+{
+	int ret;
+
+	switch (mode) {
+	case STATION_POWER_SAVE_MODE:
+		wl12xx_debug(DEBUG_PSM, "entering psm");
+		ret = wl12xx_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
+		if (ret < 0)
+			return ret;
+
+		ret = wl12xx_ps_set_elp(wl, true);
+		if (ret < 0)
+			return ret;
+
+		wl->psm = 1;
+		break;
+	case STATION_ACTIVE_MODE:
+	default:
+		wl12xx_debug(DEBUG_PSM, "leaving psm");
+		ret = wl12xx_ps_set_elp(wl, false);
+		if (ret < 0)
+			return ret;
+
+		ret = wl12xx_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
+		if (ret < 0)
+			return ret;
+
+		wl->psm = 0;
+		break;
+	}
+
+	return ret;
+}
+
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl12xx/wl1251_ps.h
new file mode 100644
index 0000000..db9f7ed
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.h
@@ -0,0 +1,36 @@
+#ifndef __WL12XX_PS_H__
+#define __WL12XX_PS_H__
+
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "wl12xx.h"
+#include "wl1251_acx.h"
+
+int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode);
+void wl12xx_ps_elp_sleep(struct wl12xx *wl);
+int wl12xx_ps_elp_wakeup(struct wl12xx *wl);
+
+
+#endif /* __WL12XX_PS_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
new file mode 100644
index 0000000..d73e014
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -0,0 +1,195 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <net/mac80211.h>
+
+#include "wl12xx.h"
+#include "reg.h"
+#include "wl1251_spi.h"
+#include "wl1251_rx.h"
+#include "wl1251_acx.h"
+
+static void wl12xx_rx_header(struct wl12xx *wl,
+			     struct wl12xx_rx_descriptor *desc)
+{
+	u32 rx_packet_ring_addr;
+
+	rx_packet_ring_addr = wl->data_path->rx_packet_ring_addr;
+	if (wl->rx_current_buffer)
+		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
+
+	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
+}
+
+static void wl12xx_rx_status(struct wl12xx *wl,
+			     struct wl12xx_rx_descriptor *desc,
+			     struct ieee80211_rx_status *status,
+			     u8 beacon)
+{
+	u64 mactime;
+	int ret;
+
+	memset(status, 0, sizeof(struct ieee80211_rx_status));
+
+	status->band = IEEE80211_BAND_2GHZ;
+	status->mactime = desc->timestamp;
+
+	/*
+	 * The rx status timestamp is a 32 bits value while the TSF is a
+	 * 64 bits one.
+	 * For IBSS merging, TSF is mandatory, so we have to get it
+	 * somehow, so we ask for ACX_TSF_INFO.
+	 * That could be moved to the get_tsf() hook, but unfortunately,
+	 * this one must be atomic, while our SPI routines can sleep.
+	 */
+	if ((wl->bss_type == BSS_TYPE_IBSS) && beacon) {
+		ret = wl12xx_acx_tsf_info(wl, &mactime);
+		if (ret == 0)
+			status->mactime = mactime;
+	}
+
+	status->signal = desc->rssi;
+	status->qual = (desc->rssi - WL12XX_RX_MIN_RSSI) * 100 /
+		(WL12XX_RX_MAX_RSSI - WL12XX_RX_MIN_RSSI);
+	status->qual = min(status->qual, 100);
+	status->qual = max(status->qual, 0);
+
+	/*
+	 * FIXME: guessing that snr needs to be divided by two, otherwise
+	 * the values don't make any sense
+	 */
+	status->noise = desc->rssi - desc->snr / 2;
+
+	status->freq = ieee80211_channel_to_frequency(desc->channel);
+
+	status->flag |= RX_FLAG_TSFT;
+
+	if (desc->flags & RX_DESC_ENCRYPTION_MASK) {
+		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
+
+		if (likely(!(desc->flags & RX_DESC_DECRYPT_FAIL)))
+			status->flag |= RX_FLAG_DECRYPTED;
+
+		if (unlikely(desc->flags & RX_DESC_MIC_FAIL))
+			status->flag |= RX_FLAG_MMIC_ERROR;
+	}
+
+	if (unlikely(!(desc->flags & RX_DESC_VALID_FCS)))
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+
+	/* FIXME: set status->rate_idx */
+}
+
+static void wl12xx_rx_body(struct wl12xx *wl,
+			   struct wl12xx_rx_descriptor *desc)
+{
+	struct sk_buff *skb;
+	struct ieee80211_rx_status status;
+	u8 *rx_buffer, beacon = 0;
+	u16 length, *fc;
+	u32 curr_id, last_id_inc, rx_packet_ring_addr;
+
+	length = WL12XX_RX_ALIGN(desc->length  - PLCP_HEADER_LENGTH);
+	curr_id = (desc->flags & RX_DESC_SEQNUM_MASK) >> RX_DESC_PACKETID_SHIFT;
+	last_id_inc = (wl->rx_last_id + 1) % (RX_MAX_PACKET_ID + 1);
+
+	if (last_id_inc != curr_id) {
+		wl12xx_warning("curr ID:%d, last ID inc:%d",
+			       curr_id, last_id_inc);
+		wl->rx_last_id = curr_id;
+	} else {
+		wl->rx_last_id = last_id_inc;
+	}
+
+	rx_packet_ring_addr = wl->data_path->rx_packet_ring_addr +
+		sizeof(struct wl12xx_rx_descriptor) + 20;
+	if (wl->rx_current_buffer)
+		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
+
+	skb = dev_alloc_skb(length);
+	if (!skb) {
+		wl12xx_error("Couldn't allocate RX frame");
+		return;
+	}
+
+	rx_buffer = skb_put(skb, length);
+	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
+
+	/* The actual lenght doesn't include the target's alignment */
+	skb->len = desc->length  - PLCP_HEADER_LENGTH;
+
+	fc = (u16 *)skb->data;
+
+	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
+		beacon = 1;
+
+	wl12xx_rx_status(wl, desc, &status, beacon);
+
+	wl12xx_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
+		     beacon ? "beacon" : "");
+
+	ieee80211_rx(wl->hw, skb, &status);
+}
+
+static void wl12xx_rx_ack(struct wl12xx *wl)
+{
+	u32 data, addr;
+
+	if (wl->rx_current_buffer) {
+		addr = ACX_REG_INTERRUPT_TRIG_H;
+		data = INTR_TRIG_RX_PROC1;
+	} else {
+		addr = ACX_REG_INTERRUPT_TRIG;
+		data = INTR_TRIG_RX_PROC0;
+	}
+
+	wl12xx_reg_write32(wl, addr, data);
+
+	/* Toggle buffer ring */
+	wl->rx_current_buffer = !wl->rx_current_buffer;
+}
+
+
+void wl12xx_rx(struct wl12xx *wl)
+{
+	struct wl12xx_rx_descriptor *rx_desc;
+
+	if (wl->state != WL12XX_STATE_ON)
+		return;
+
+	rx_desc = wl->rx_descriptor;
+
+	/* We first read the frame's header */
+	wl12xx_rx_header(wl, rx_desc);
+
+	/* Now we can read the body */
+	wl12xx_rx_body(wl, rx_desc);
+
+	/* Finally, we need to ACK the RX */
+	wl12xx_rx_ack(wl);
+
+	return;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.h b/drivers/net/wireless/wl12xx/wl1251_rx.h
new file mode 100644
index 0000000..8a23fde
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.h
@@ -0,0 +1,122 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_RX_H__
+#define __WL12XX_RX_H__
+
+#include <linux/bitops.h>
+
+/*
+ * RX PATH
+ *
+ * The Rx path uses a double buffer and an rx_contro structure, each located
+ * at a fixed address in the device memory. The host keeps track of which
+ * buffer is available and alternates between them on a per packet basis.
+ * The size of each of the two buffers is large enough to hold the longest
+ * 802.3 packet.
+ * The RX path goes like that:
+ * 1) The target generates an interrupt each time a new packet is received.
+ *   There are 2 RX interrupts, one for each buffer.
+ * 2) The host reads the received packet from one of the double buffers.
+ * 3) The host triggers a target interrupt.
+ * 4) The target prepares the next RX packet.
+ */
+
+#define WL12XX_RX_MAX_RSSI -30
+#define WL12XX_RX_MIN_RSSI -95
+
+#define WL12XX_RX_ALIGN_TO 4
+#define WL12XX_RX_ALIGN(len) (((len) + WL12XX_RX_ALIGN_TO - 1) & \
+			     ~(WL12XX_RX_ALIGN_TO - 1))
+
+#define SHORT_PREAMBLE_BIT   BIT(0)
+#define OFDM_RATE_BIT        BIT(6)
+#define PBCC_RATE_BIT        BIT(7)
+
+#define PLCP_HEADER_LENGTH 8
+#define RX_DESC_PACKETID_SHIFT 11
+#define RX_MAX_PACKET_ID 3
+
+#define RX_DESC_VALID_FCS         0x0001
+#define RX_DESC_MATCH_RXADDR1     0x0002
+#define RX_DESC_MCAST             0x0004
+#define RX_DESC_STAINTIM          0x0008
+#define RX_DESC_VIRTUAL_BM        0x0010
+#define RX_DESC_BCAST             0x0020
+#define RX_DESC_MATCH_SSID        0x0040
+#define RX_DESC_MATCH_BSSID       0x0080
+#define RX_DESC_ENCRYPTION_MASK   0x0300
+#define RX_DESC_MEASURMENT        0x0400
+#define RX_DESC_SEQNUM_MASK       0x1800
+#define	RX_DESC_MIC_FAIL	  0x2000
+#define	RX_DESC_DECRYPT_FAIL	  0x4000
+
+struct wl12xx_rx_descriptor {
+	u32 timestamp; /* In microseconds */
+	u16 length; /* Paylod length, including headers */
+	u16 flags;
+
+	/*
+	 * 0 - 802.11
+	 * 1 - 802.3
+	 * 2 - IP
+	 * 3 - Raw Codec
+	 */
+	u8 type;
+
+	/*
+	 * Recevied Rate:
+	 * 0x0A - 1MBPS
+	 * 0x14 - 2MBPS
+	 * 0x37 - 5_5MBPS
+	 * 0x0B - 6MBPS
+	 * 0x0F - 9MBPS
+	 * 0x6E - 11MBPS
+	 * 0x0A - 12MBPS
+	 * 0x0E - 18MBPS
+	 * 0xDC - 22MBPS
+	 * 0x09 - 24MBPS
+	 * 0x0D - 36MBPS
+	 * 0x08 - 48MBPS
+	 * 0x0C - 54MBPS
+	 */
+	u8 rate;
+
+	u8 mod_pre; /* Modulation and preamble */
+	u8 channel;
+
+	/*
+	 * 0 - 2.4 Ghz
+	 * 1 - 5 Ghz
+	 */
+	u8 band;
+
+	s8 rssi; /* in dB */
+	u8 rcpi; /* in dB */
+	u8 snr; /* in dB */
+} __attribute__ ((packed));
+
+void wl12xx_rx(struct wl12xx *wl);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
new file mode 100644
index 0000000..d7eee8c
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -0,0 +1,394 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "wl1251_spi.h"
+
+static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
+{
+	/* If the address is lower than REGISTERS_BASE, it means that this is
+	 * a chip-specific register address, so look it up in the registers
+	 * table */
+	if (addr < REGISTERS_BASE) {
+		/* Make sure we don't go over the table */
+		if (addr >= ACX_REG_TABLE_LEN) {
+			wl12xx_error("address out of range (%d)", addr);
+			return -EINVAL;
+		}
+		addr = wl->chip.acx_reg_table[addr];
+	}
+
+	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
+}
+
+static int wl12xx_translate_mem_addr(struct wl12xx *wl, int addr)
+{
+	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
+}
+
+
+void wl12xx_spi_reset(struct wl12xx *wl)
+{
+	u8 *cmd;
+	struct spi_transfer t;
+	struct spi_message m;
+
+	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
+	if (!cmd) {
+		wl12xx_error("could not allocate cmd for spi reset");
+		return;
+	}
+
+	memset(&t, 0, sizeof(t));
+	spi_message_init(&m);
+
+	memset(cmd, 0xff, WSPI_INIT_CMD_LEN);
+
+	t.tx_buf = cmd;
+	t.len = WSPI_INIT_CMD_LEN;
+	spi_message_add_tail(&t, &m);
+
+	spi_sync(wl->spi, &m);
+
+	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
+}
+
+void wl12xx_spi_init(struct wl12xx *wl)
+{
+	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
+	struct spi_transfer t;
+	struct spi_message m;
+
+	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
+	if (!cmd) {
+		wl12xx_error("could not allocate cmd for spi init");
+		return;
+	}
+
+	memset(crc, 0, sizeof(crc));
+	memset(&t, 0, sizeof(t));
+	spi_message_init(&m);
+
+	/*
+	 * Set WSPI_INIT_COMMAND
+	 * the data is being send from the MSB to LSB
+	 */
+	cmd[2] = 0xff;
+	cmd[3] = 0xff;
+	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
+	cmd[0] = 0;
+	cmd[7] = 0;
+	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
+	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+
+	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
+		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
+	else
+		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
+
+	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
+		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
+
+	crc[0] = cmd[1];
+	crc[1] = cmd[0];
+	crc[2] = cmd[7];
+	crc[3] = cmd[6];
+	crc[4] = cmd[5];
+
+	cmd[4] |= crc7(0, crc, WSPI_INIT_CMD_CRC_LEN) << 1;
+	cmd[4] |= WSPI_INIT_CMD_END;
+
+	t.tx_buf = cmd;
+	t.len = WSPI_INIT_CMD_LEN;
+	spi_message_add_tail(&t, &m);
+
+	spi_sync(wl->spi, &m);
+
+	wl12xx_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
+}
+
+/* Set the SPI partitions to access the chip addresses
+ *
+ * There are two VIRTUAL (SPI) partitions (the memory partition and the
+ * registers partition), which are mapped to two different areas of the
+ * PHYSICAL (hardware) memory.  This function also makes other checks to
+ * ensure that the partitions are not overlapping.  In the diagram below, the
+ * memory partition comes before the register partition, but the opposite is
+ * also supported.
+ *
+ *                               PHYSICAL address
+ *                                     space
+ *
+ *                                    |    |
+ *                                 ...+----+--> mem_start
+ *          VIRTUAL address     ...   |    |
+ *               space       ...      |    | [PART_0]
+ *                        ...         |    |
+ * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
+ *               |    |         ...   |    |
+ *               |MEM |      ...      |    |
+ *               |    |   ...         |    |
+ *  part_size <--+----+...            |    | {unused area)
+ *               |    |   ...         |    |
+ *               |REG |      ...      |    |
+ *  part_size    |    |         ...   |    |
+ *      +     <--+----+...         ...+----+--> reg_start
+ *  reg_size              ...         |    |
+ *                           ...      |    | [PART_1]
+ *                              ...   |    |
+ *                                 ...+----+--> reg_start + reg_size
+ *                                    |    |
+ *
+ */
+int wl12xx_set_partition(struct wl12xx *wl,
+			  u32 mem_start, u32 mem_size,
+			  u32 reg_start, u32 reg_size)
+{
+	struct wl12xx_partition *partition;
+	struct spi_transfer t;
+	struct spi_message m;
+	size_t len, cmd_len;
+	u32 *cmd;
+	int addr;
+
+	cmd_len = sizeof(u32) + 2 * sizeof(struct wl12xx_partition);
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	spi_message_init(&m);
+	memset(&t, 0, sizeof(t));
+
+	partition = (struct wl12xx_partition *) (cmd + 1);
+	addr = HW_ACCESS_PART0_SIZE_ADDR;
+	len = 2 * sizeof(struct wl12xx_partition);
+
+	*cmd |= WSPI_CMD_WRITE;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+
+	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		     mem_start, mem_size);
+	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		     reg_start, reg_size);
+
+	/* Make sure that the two partitions together don't exceed the
+	 * address range */
+	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
+		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
+			     " address range.  Truncating partition[0].");
+		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	if ((mem_start < reg_start) &&
+	    ((mem_start + mem_size) > reg_start)) {
+		/* Guarantee that the memory partition doesn't overlap the
+		 * registers partition */
+		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
+			     "overlapping partition[1].  Adjusted.");
+		mem_size = reg_start - mem_start;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	} else if ((reg_start < mem_start) &&
+		   ((reg_start + reg_size) > mem_start)) {
+		/* Guarantee that the register partition doesn't overlap the
+		 * memory partition */
+		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
+			     " overlapping partition[0].  Adjusted.");
+		reg_size = mem_start - reg_start;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	partition[0].start = mem_start;
+	partition[0].size  = mem_size;
+	partition[1].start = reg_start;
+	partition[1].size  = reg_size;
+
+	wl->physical_mem_addr = mem_start;
+	wl->physical_reg_addr = reg_start;
+
+	wl->virtual_mem_addr = 0;
+	wl->virtual_reg_addr = mem_size;
+
+	t.tx_buf = cmd;
+	t.len = cmd_len;
+	spi_message_add_tail(&t, &m);
+
+	spi_sync(wl->spi, &m);
+
+	kfree(cmd);
+
+	return 0;
+}
+
+void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
+		     size_t len, bool fixed)
+{
+	struct spi_transfer t[3];
+	struct spi_message m;
+	u8 *busy_buf;
+	u32 *cmd;
+
+	cmd = &wl->buffer_cmd;
+	busy_buf = wl->buffer_busyword;
+
+	*cmd = 0;
+	*cmd |= WSPI_CMD_READ;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+
+	if (fixed)
+		*cmd |= WSPI_CMD_FIXED;
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].tx_buf = cmd;
+	t[0].len = 4;
+	spi_message_add_tail(&t[0], &m);
+
+	/* Busy and non busy words read */
+	t[1].rx_buf = busy_buf;
+	t[1].len = WL12XX_BUSY_WORD_LEN;
+	spi_message_add_tail(&t[1], &m);
+
+	t[2].rx_buf = buf;
+	t[2].len = len;
+	spi_message_add_tail(&t[2], &m);
+
+	spi_sync(wl->spi, &m);
+
+	/* FIXME: check busy words */
+
+	wl12xx_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
+	wl12xx_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
+}
+
+void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
+		      size_t len, bool fixed)
+{
+	struct spi_transfer t[2];
+	struct spi_message m;
+	u32 *cmd;
+
+	cmd = &wl->buffer_cmd;
+
+	*cmd = 0;
+	*cmd |= WSPI_CMD_WRITE;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+
+	if (fixed)
+		*cmd |= WSPI_CMD_FIXED;
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].tx_buf = cmd;
+	t[0].len = sizeof(*cmd);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].tx_buf = buf;
+	t[1].len = len;
+	spi_message_add_tail(&t[1], &m);
+
+	spi_sync(wl->spi, &m);
+
+	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
+	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
+}
+
+void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf,
+			 size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_mem_addr(wl, addr);
+
+	wl12xx_spi_read(wl, physical, buf, len, false);
+}
+
+void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
+			  size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_mem_addr(wl, addr);
+
+	wl12xx_spi_write(wl, physical, buf, len, false);
+}
+
+void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
+			 bool fixed)
+{
+	int physical;
+
+	physical = wl12xx_translate_reg_addr(wl, addr);
+
+	wl12xx_spi_read(wl, physical, buf, len, fixed);
+}
+
+void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
+			  bool fixed)
+{
+	int physical;
+
+	physical = wl12xx_translate_reg_addr(wl, addr);
+
+	wl12xx_spi_write(wl, physical, buf, len, fixed);
+}
+
+u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
+{
+	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
+}
+
+void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl12xx_write32(wl, wl12xx_translate_mem_addr(wl, addr), val);
+}
+
+u32 wl12xx_reg_read32(struct wl12xx *wl, int addr)
+{
+	return wl12xx_read32(wl, wl12xx_translate_reg_addr(wl, addr));
+}
+
+void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
new file mode 100644
index 0000000..82b009c
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -0,0 +1,115 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_SPI_H__
+#define __WL12XX_SPI_H__
+
+#include "wl1251_cmd.h"
+#include "wl1251_acx.h"
+#include "reg.h"
+
+#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
+
+#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
+#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
+#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
+#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
+
+#define HW_ACCESS_REGISTER_SIZE             4
+
+#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
+
+#define WSPI_CMD_READ                 0x40000000
+#define WSPI_CMD_WRITE                0x00000000
+#define WSPI_CMD_FIXED                0x20000000
+#define WSPI_CMD_BYTE_LENGTH          0x1FFE0000
+#define WSPI_CMD_BYTE_LENGTH_OFFSET   17
+#define WSPI_CMD_BYTE_ADDR            0x0001FFFF
+
+#define WSPI_INIT_CMD_CRC_LEN       5
+
+#define WSPI_INIT_CMD_START         0x00
+#define WSPI_INIT_CMD_TX            0x40
+/* the extra bypass bit is sampled by the TNET as '1' */
+#define WSPI_INIT_CMD_BYPASS_BIT    0x80
+#define WSPI_INIT_CMD_FIXEDBUSY_LEN 0x07
+#define WSPI_INIT_CMD_EN_FIXEDBUSY  0x80
+#define WSPI_INIT_CMD_DIS_FIXEDBUSY 0x00
+#define WSPI_INIT_CMD_IOD           0x40
+#define WSPI_INIT_CMD_IP            0x20
+#define WSPI_INIT_CMD_CS            0x10
+#define WSPI_INIT_CMD_WS            0x08
+#define WSPI_INIT_CMD_WSPI          0x01
+#define WSPI_INIT_CMD_END           0x01
+
+#define WSPI_INIT_CMD_LEN           8
+
+#define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
+		((WL12XX_BUSY_WORD_LEN - 4) / sizeof(u32))
+#define HW_ACCESS_WSPI_INIT_CMD_MASK  0
+
+
+/* Raw target IO, address is not translated */
+void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
+		      size_t len, bool fixed);
+void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
+		     size_t len, bool fixed);
+
+/* Memory target IO, address is tranlated to partition 0 */
+void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len);
+u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
+void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
+
+/* Registers IO */
+void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
+			 bool fixed);
+void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
+			  bool fixed);
+u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
+void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
+
+/* INIT and RESET words */
+void wl12xx_spi_reset(struct wl12xx *wl);
+void wl12xx_spi_init(struct wl12xx *wl);
+int wl12xx_set_partition(struct wl12xx *wl,
+			 u32 part_start, u32 part_size,
+			 u32 reg_start,  u32 reg_size);
+
+static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
+{
+	wl12xx_spi_read(wl, addr, &wl->buffer_32,
+			sizeof(wl->buffer_32), false);
+
+	return wl->buffer_32;
+}
+
+static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
+{
+	wl->buffer_32 = val;
+	wl12xx_spi_write(wl, addr, &wl->buffer_32,
+			 sizeof(wl->buffer_32), false);
+}
+
+#endif /* __WL12XX_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index 10023fc..c57330e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -27,9 +27,9 @@
 
 #include "wl12xx.h"
 #include "reg.h"
-#include "spi.h"
+#include "wl1251_spi.h"
 #include "wl1251_tx.h"
-#include "ps.h"
+#include "wl1251_ps.h"
 
 static bool wl1251_tx_double_buffer_busy(struct wl12xx *wl, u32 data_out_count)
 {

