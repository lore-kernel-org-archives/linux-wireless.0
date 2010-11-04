Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37232 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0KDOxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 10:53:14 -0400
Received: by qyk12 with SMTP id 12so1503257qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 07:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288882189-29945-1-git-send-email-shahar_levi@ti.com>
References: <1288882189-29945-1-git-send-email-shahar_levi@ti.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 4 Nov 2010 15:52:53 +0100
Message-ID: <AANLkTi=zfrodP3qWu-PH0jhARob2PH7EGs8QoJM+bnFk@mail.gmail.com>
Subject: Re: [PATCH v3] wl1271: Change wl12xx Files Names
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 3:49 PM, Shahar Levi <shahar_levi@ti.com> wrote:
> All files name prefix removed due to the fuct that wl12xx driver supports

What the fuct? :-)

> wl1271 and wl1273.
> Also the definition in Kconfig and header files changed respectively.
>
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---
> Changes from v1:
> - Rename header files protect define to the file name
> - Definition naming in Kconfig
>
> Changes from v2:
> - Fix four comments words in Kconfig
> - Replace wl1271-$(CONFIG_NL80211_TESTMODE) with wl12xx-$(CONFIG_NL80211_TESTMODE)
> - Rebase to latest
>
>  drivers/net/wireless/wl12xx/Kconfig                |   51 ++++++++++----------
>  drivers/net/wireless/wl12xx/Makefile               |   17 ++++---
>  .../net/wireless/wl12xx/{wl1271_acx.c => acx.c}    |    8 ++--
>  .../net/wireless/wl12xx/{wl1271_acx.h => acx.h}    |    8 ++--
>  .../net/wireless/wl12xx/{wl1271_boot.c => boot.c}  |   10 ++--
>  .../net/wireless/wl12xx/{wl1271_boot.h => boot.h}  |    2 +-
>  .../net/wireless/wl12xx/{wl1271_cmd.c => cmd.c}    |   12 ++--
>  .../net/wireless/wl12xx/{wl1271_cmd.h => cmd.h}    |    6 +-
>  .../net/wireless/wl12xx/{wl1271_conf.h => conf.h}  |    4 +-
>  .../wl12xx/{wl1271_debugfs.c => debugfs.c}         |   10 ++--
>  .../wl12xx/{wl1271_debugfs.h => debugfs.h}         |    6 +-
>  .../wireless/wl12xx/{wl1271_event.c => event.c}    |   12 ++--
>  .../wireless/wl12xx/{wl1271_event.h => event.h}    |    4 +-
>  .../net/wireless/wl12xx/{wl1271_ini.h => ini.h}    |    4 +-
>  .../net/wireless/wl12xx/{wl1271_init.c => init.c}  |    8 ++--
>  .../net/wireless/wl12xx/{wl1271_init.h => init.h}  |    6 +-
>  drivers/net/wireless/wl12xx/{wl1271_io.c => io.c}  |    4 +-
>  drivers/net/wireless/wl12xx/{wl1271_io.h => io.h}  |    6 +-
>  .../net/wireless/wl12xx/{wl1271_main.c => main.c}  |   38 +++++++-------
>  drivers/net/wireless/wl12xx/{wl1271_ps.c => ps.c}  |    6 +-
>  drivers/net/wireless/wl12xx/{wl1271_ps.h => ps.h}  |    8 ++--
>  .../net/wireless/wl12xx/{wl1271_reg.h => reg.h}    |    0
>  drivers/net/wireless/wl12xx/{wl1271_rx.c => rx.c}  |   12 ++--
>  drivers/net/wireless/wl12xx/{wl1271_rx.h => rx.h}  |    4 +-
>  .../net/wireless/wl12xx/{wl1271_scan.c => scan.c}  |    8 ++--
>  .../net/wireless/wl12xx/{wl1271_scan.h => scan.h}  |    6 +-
>  .../net/wireless/wl12xx/{wl1271_sdio.c => sdio.c}  |    4 +-
>  .../net/wireless/wl12xx/{wl1271_spi.c => spi.c}    |    6 +-
>  .../wl12xx/{wl1271_testmode.c => testmode.c}       |    6 +-
>  .../wl12xx/{wl1271_testmode.h => testmode.h}       |    4 +-
>  drivers/net/wireless/wl12xx/{wl1271_tx.c => tx.c}  |   12 ++--
>  drivers/net/wireless/wl12xx/{wl1271_tx.h => tx.h}  |    4 +-
>  drivers/net/wireless/wl12xx/{wl1271.h => wl12xx.h} |    8 ++--
>  33 files changed, 153 insertions(+), 151 deletions(-)
>  rename drivers/net/wireless/wl12xx/{wl1271_acx.c => acx.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_acx.h => acx.h} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_boot.c => boot.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_boot.h => boot.h} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_cmd.c => cmd.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_cmd.h => cmd.h} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_conf.h => conf.h} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_debugfs.c => debugfs.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_debugfs.h => debugfs.h} (93%)
>  rename drivers/net/wireless/wl12xx/{wl1271_event.c => event.c} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_event.h => event.h} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_ini.h => ini.h} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_init.c => init.c} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_init.h => init.h} (93%)
>  rename drivers/net/wireless/wl12xx/{wl1271_io.c => io.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_io.h => io.h} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_main.c => main.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_ps.c => ps.c} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_ps.h => ps.h} (92%)
>  rename drivers/net/wireless/wl12xx/{wl1271_reg.h => reg.h} (100%)
>  rename drivers/net/wireless/wl12xx/{wl1271_rx.c => rx.c} (97%)
>  rename drivers/net/wireless/wl12xx/{wl1271_rx.h => rx.h} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_scan.c => scan.c} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_scan.h => scan.h} (97%)
>  rename drivers/net/wireless/wl12xx/{wl1271_sdio.c => sdio.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_spi.c => spi.c} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271_testmode.c => testmode.c} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_testmode.h => testmode.h} (93%)
>  rename drivers/net/wireless/wl12xx/{wl1271_tx.c => tx.c} (98%)
>  rename drivers/net/wireless/wl12xx/{wl1271_tx.h => tx.h} (99%)
>  rename drivers/net/wireless/wl12xx/{wl1271.h => wl1wl1271-$(CONFIG_NL80211_TESTMODE)2xx.h} (99%)
>
> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> index 1b3b7bd..2250db5 100644
> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -1,56 +1,57 @@
> -menuconfig WL12XX
> +menuconfig WL12XX_MENU
>        tristate "TI wl12xx driver support"
>        depends on MAC80211 && EXPERIMENTAL
>        ---help---
> -         This will enable TI wl12xx driver support. The drivers make
> -         use of the mac80211 stack.
> +         This will enable TI wl12xx driver support for the following chips:
> +         wl1271 and wl1273.
> +         The drivers make use of the mac80211 stack.
>
> -config WL1271
> -       tristate "TI wl1271 support"
> -       depends on WL12XX && GENERIC_HARDIRQS
> +config WL12XX
> +       tristate "TI wl12xx support"
> +       depends on WL12XX_MENU && GENERIC_HARDIRQS
>        depends on INET
>        select FW_LOADER
>        select CRC7
>        ---help---
> -         This module adds support for wireless adapters based on the
> -         TI wl1271 chipset.
> +         This module adds support for wireless adapters based on TI wl1271
> +         and TI wl1273 chipsets
>
> -         If you choose to build a module, it'll be called wl1271. Say N if
> +         If you choose to build a module, it will be called wl12xx. Say N if
>          unsure.
>
> -config WL1271_HT
> -        bool "TI wl1271 802.11 HT support (EXPERIMENTAL)"
> -        depends on WL1271 && EXPERIMENTAL
> +config WL12XX_HT
> +        bool "TI wl12xx 802.11 HT support (EXPERIMENTAL)"
> +        depends on WL12XX && EXPERIMENTAL
>         default n
>         ---help---
> -          This will enable 802.11 HT support for TI wl1271 chipset.
> +          This will enable 802.11 HT support in the wl12xx module.
>
>          That configuration is temporary due to the code incomplete and
>          still in testing process.
>
> -config WL1271_SPI
> -       tristate "TI wl1271 SPI support"
> -       depends on WL1271 && SPI_MASTER
> +config WL12XX_SPI
> +       tristate "TI wl12xx SPI support"
> +       depends on WL12XX && SPI_MASTER
>        ---help---
>          This module adds support for the SPI interface of adapters using
> -         TI wl1271 chipset.  Select this if your platform is using
> +         TI wl12xx chipsets.  Select this if your platform is using
>          the SPI bus.
>
> -         If you choose to build a module, it'll be called wl1251_spi.
> +         If you choose to build a module, it'll be called wl12xx_spi.
>          Say N if unsure.
>
> -config WL1271_SDIO
> -       tristate "TI wl1271 SDIO support"
> -       depends on WL1271 && MMC
> +config WL12XX_SDIO
> +       tristate "TI wl12xx SDIO support"
> +       depends on WL12XX && MMC
>        ---help---
>          This module adds support for the SDIO interface of adapters using
> -         TI wl1271 chipset.  Select this if your platform is using
> +         TI wl12xx chipsets.  Select this if your platform is using
>          the SDIO bus.
>
> -         If you choose to build a module, it'll be called
> -         wl1271_sdio. Say N if unsure.
> +         If you choose to build a module, it'll be called wl12xx_sdio.
> +         Say N if unsure.
>
>  config WL12XX_PLATFORM_DATA
>        bool
> -       depends on WL1271_SDIO != n
> +       depends on WL12XX_SDIO != n
>        default y
> diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
> index 3a80744..005a758 100644
> --- a/drivers/net/wireless/wl12xx/Makefile
> +++ b/drivers/net/wireless/wl12xx/Makefile
> @@ -1,12 +1,13 @@
> -wl1271-objs            = wl1271_main.o  wl1271_cmd.o wl1271_io.o \
> -                         wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
> -                         wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
> -                         wl1271_init.o  wl1271_debugfs.o wl1271_scan.o
> +wl12xx-objs            = main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
> +                         boot.o init.o debugfs.o scan.o
>
> -wl1271-$(CONFIG_NL80211_TESTMODE)      += wl1271_testmode.o
> -obj-$(CONFIG_WL1271)   += wl1271.o
> -obj-$(CONFIG_WL1271_SPI)       += wl1271_spi.o
> -obj-$(CONFIG_WL1271_SDIO)      += wl1271_sdio.o
> +wl12xx_spi-objs        = spi.o
> +wl12xx_sdio-objs       = sdio.o
> +
> +wl12xx-$(CONFIG_NL80211_TESTMODE)      += testmode.o
> +obj-$(CONFIG_WL12XX)                   += wl12xx.o
> +obj-$(CONFIG_WL12XX_SPI)               += wl12xx_spi.o
> +obj-$(CONFIG_WL12XX_SDIO)              += wl12xx_sdio.o
>
>  # small builtin driver bit
>  obj-$(CONFIG_WL12XX_PLATFORM_DATA)     += wl12xx_platform_data.o
> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/acx.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_acx.c
> rename to drivers/net/wireless/wl12xx/acx.c
> index bd7f95f..bc1085b 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -21,7 +21,7 @@
>  *
>  */
>
> -#include "wl1271_acx.h"
> +#include "acx.h"
>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -29,10 +29,10 @@
>  #include <linux/spi/spi.h>
>  #include <linux/slab.h>
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_ps.h"
> +#include "reg.h"
> +#include "ps.h"
>
>  int wl1271_acx_wake_up_conditions(struct wl1271 *wl)
>  {
> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/acx.h
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_acx.h
> rename to drivers/net/wireless/wl12xx/acx.h
> index b7c4908..f41a9c1 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h
> @@ -22,11 +22,11 @@
>  *
>  */
>
> -#ifndef __WL1271_ACX_H__
> -#define __WL1271_ACX_H__
> +#ifndef __ACX_H__
> +#define __ACX_H__
>
> -#include "wl1271.h"
> -#include "wl1271_cmd.h"
> +#include "wl12xx.h"
> +#include "cmd.h"
>
>  /*************************************************************************
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/boot.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_boot.c
> rename to drivers/net/wireless/wl12xx/boot.c
> index 5b19072..1eafb81 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_boot.c
> +++ b/drivers/net/wireless/wl12xx/boot.c
> @@ -24,11 +24,11 @@
>  #include <linux/gpio.h>
>  #include <linux/slab.h>
>
> -#include "wl1271_acx.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_boot.h"
> -#include "wl1271_io.h"
> -#include "wl1271_event.h"
> +#include "acx.h"
> +#include "reg.h"
> +#include "boot.h"
> +#include "io.h"
> +#include "event.h"
>
>  static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
>        [PART_DOWN] = {
> diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/boot.h
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_boot.h
> rename to drivers/net/wireless/wl12xx/boot.h
> index f73b0b1..c7d7719 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_boot.h
> +++ b/drivers/net/wireless/wl12xx/boot.h
> @@ -24,7 +24,7 @@
>  #ifndef __BOOT_H__
>  #define __BOOT_H__
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>
>  int wl1271_boot(struct wl1271 *wl);
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_cmd.c
> rename to drivers/net/wireless/wl12xx/cmd.c
> index 5d3e848..f3d0541 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -29,13 +29,13 @@
>  #include <linux/ieee80211.h>
>  #include <linux/slab.h>
>
> -#include "wl1271.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_io.h"
> -#include "wl1271_acx.h"
> +#include "wl12xx.h"
> +#include "reg.h"
> +#include "io.h"
> +#include "acx.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_cmd.h"
> -#include "wl1271_event.h"
> +#include "cmd.h"
> +#include "event.h"
>
>  #define WL1271_CMD_FAST_POLL_COUNT       50
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/cmd.h
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_cmd.h
> rename to drivers/net/wireless/wl12xx/cmd.h
> index a0caf4f..893dbf7 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
> +++ b/drivers/net/wireless/wl12xx/cmd.h
> @@ -22,10 +22,10 @@
>  *
>  */
>
> -#ifndef __WL1271_CMD_H__
> -#define __WL1271_CMD_H__
> +#ifndef __CMD_H__
> +#define __CMD_H__
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>
>  struct acx_header;
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/conf.h
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_conf.h
> rename to drivers/net/wireless/wl12xx/conf.h
> index 5f78a6c..a16b361 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_conf.h
> +++ b/drivers/net/wireless/wl12xx/conf.h
> @@ -21,8 +21,8 @@
>  *
>  */
>
> -#ifndef __WL1271_CONF_H__
> -#define __WL1271_CONF_H__
> +#ifndef __CONF_H__
> +#define __CONF_H__
>
>  enum {
>        CONF_HW_BIT_RATE_1MBPS   = BIT(0),
> diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_debugfs.c
> rename to drivers/net/wireless/wl12xx/debugfs.c
> index 3468b84..dd71b7d 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
> +++ b/drivers/net/wireless/wl12xx/debugfs.c
> @@ -21,15 +21,15 @@
>  *
>  */
>
> -#include "wl1271_debugfs.h"
> +#include "debugfs.h"
>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
>
> -#include "wl1271.h"
> -#include "wl1271_acx.h"
> -#include "wl1271_ps.h"
> -#include "wl1271_io.h"
> +#include "wl12xx.h"
> +#include "acx.h"
> +#include "ps.h"
> +#include "io.h"
>
>  /* ms */
>  #define WL1271_DEBUGFS_STATS_LIFETIME 1000
> diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.h b/drivers/net/wireless/wl12xx/debugfs.h
> similarity index 93%
> rename from drivers/net/wireless/wl12xx/wl1271_debugfs.h
> rename to drivers/net/wireless/wl12xx/debugfs.h
> index 00a45b2..254c5b2 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_debugfs.h
> +++ b/drivers/net/wireless/wl12xx/debugfs.h
> @@ -21,10 +21,10 @@
>  *
>  */
>
> -#ifndef WL1271_DEBUGFS_H
> -#define WL1271_DEBUGFS_H
> +#ifndef __DEBUGFS_H__
> +#define __DEBUGFS_H__
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>
>  int wl1271_debugfs_init(struct wl1271 *wl);
>  void wl1271_debugfs_exit(struct wl1271 *wl);
> diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/event.c
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_event.c
> rename to drivers/net/wireless/wl12xx/event.c
> index 38ccef7..f9146f5 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_event.c
> +++ b/drivers/net/wireless/wl12xx/event.c
> @@ -21,12 +21,12 @@
>  *
>  */
>
> -#include "wl1271.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_io.h"
> -#include "wl1271_event.h"
> -#include "wl1271_ps.h"
> -#include "wl1271_scan.h"
> +#include "wl12xx.h"
> +#include "reg.h"
> +#include "io.h"
> +#include "event.h"
> +#include "ps.h"
> +#include "scan.h"
>  #include "wl12xx_80211.h"
>
>  void wl1271_pspoll_work(struct work_struct *work)
> diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/event.h
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_event.h
> rename to drivers/net/wireless/wl12xx/event.h
> index e475166..6cce014 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_event.h
> +++ b/drivers/net/wireless/wl12xx/event.h
> @@ -22,8 +22,8 @@
>  *
>  */
>
> -#ifndef __WL1271_EVENT_H__
> -#define __WL1271_EVENT_H__
> +#ifndef __EVENT_H__
> +#define __EVENT_H__
>
>  /*
>  * Mbox events
> diff --git a/drivers/net/wireless/wl12xx/wl1271_ini.h b/drivers/net/wireless/wl12xx/ini.h
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_ini.h
> rename to drivers/net/wireless/wl12xx/ini.h
> index 2313047..c330a25 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_ini.h
> +++ b/drivers/net/wireless/wl12xx/ini.h
> @@ -21,8 +21,8 @@
>  *
>  */
>
> -#ifndef __WL1271_INI_H__
> -#define __WL1271_INI_H__
> +#ifndef __INI_H__
> +#define __INI_H__
>
>  #define WL1271_INI_MAX_SMART_REFLEX_PARAM 16
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/init.c
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_init.c
> rename to drivers/net/wireless/wl12xx/init.c
> index 8044bba..492edc0 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_init.c
> +++ b/drivers/net/wireless/wl12xx/init.c
> @@ -25,11 +25,11 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>
> -#include "wl1271_init.h"
> +#include "init.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_acx.h"
> -#include "wl1271_cmd.h"
> -#include "wl1271_reg.h"
> +#include "acx.h"
> +#include "cmd.h"
> +#include "reg.h"
>
>  static int wl1271_init_hwenc_config(struct wl1271 *wl)
>  {
> diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/init.h
> similarity index 93%
> rename from drivers/net/wireless/wl12xx/wl1271_init.h
> rename to drivers/net/wireless/wl12xx/init.h
> index bc26f8c..7762421 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_init.h
> +++ b/drivers/net/wireless/wl12xx/init.h
> @@ -21,10 +21,10 @@
>  *
>  */
>
> -#ifndef __WL1271_INIT_H__
> -#define __WL1271_INIT_H__
> +#ifndef __INIT_H__
> +#define __INIT_H__
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>
>  int wl1271_hw_init_power_auth(struct wl1271 *wl);
>  int wl1271_init_templates_config(struct wl1271 *wl);
> diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/io.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_io.c
> rename to drivers/net/wireless/wl12xx/io.c
> index c8759ac..35c2f1a 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_io.c
> +++ b/drivers/net/wireless/wl12xx/io.c
> @@ -26,9 +26,9 @@
>  #include <linux/crc7.h>
>  #include <linux/spi/spi.h>
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_io.h"
> +#include "io.h"
>
>  #define OCP_CMD_LOOP  32
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/io.h
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_io.h
> rename to drivers/net/wireless/wl12xx/io.h
> index c1f92e6..844b32b 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_io.h
> +++ b/drivers/net/wireless/wl12xx/io.h
> @@ -22,10 +22,10 @@
>  *
>  */
>
> -#ifndef __WL1271_IO_H__
> -#define __WL1271_IO_H__
> +#ifndef __IO_H__
> +#define __IO_H__
>
> -#include "wl1271_reg.h"
> +#include "reg.h"
>
>  #define HW_ACCESS_MEMORY_MAX_RANGE     0x1FFC0
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/main.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_main.c
> rename to drivers/net/wireless/wl12xx/main.c
> index f5b1d19..c005230 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -31,20 +31,20 @@
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_io.h"
> -#include "wl1271_event.h"
> -#include "wl1271_tx.h"
> -#include "wl1271_rx.h"
> -#include "wl1271_ps.h"
> -#include "wl1271_init.h"
> -#include "wl1271_debugfs.h"
> -#include "wl1271_cmd.h"
> -#include "wl1271_boot.h"
> -#include "wl1271_testmode.h"
> -#include "wl1271_scan.h"
> +#include "reg.h"
> +#include "io.h"
> +#include "event.h"
> +#include "tx.h"
> +#include "rx.h"
> +#include "ps.h"
> +#include "init.h"
> +#include "debugfs.h"
> +#include "cmd.h"
> +#include "boot.h"
> +#include "testmode.h"
> +#include "scan.h"
>
>  #define WL1271_BOOT_RETRIES 3
>
> @@ -884,7 +884,7 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>                set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
>        }
>
> -#ifdef CONFIG_WL1271_HT
> +#ifdef CONFIG_WL12XX_HT
>        if (sta &&
>            sta->ht_cap.ht_supported &&
>            ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=
> @@ -2247,8 +2247,8 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
>  /* 11n STA capabilities */
>  #define HW_RX_HIGHEST_RATE     72
>
> -#ifdef CONFIG_WL1271_HT
> -#define WL1271_HT_CAP { \
> +#ifdef CONFIG_WL12XX_HT
> +#define WL12XX_HT_CAP { \
>        .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20, \
>        .ht_supported = true, \
>        .ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K, \
> @@ -2260,7 +2260,7 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
>                }, \
>  }
>  #else
> -#define WL1271_HT_CAP { \
> +#define WL12XX_HT_CAP { \
>        .ht_supported = false, \
>  }
>  #endif
> @@ -2271,7 +2271,7 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
>        .n_channels = ARRAY_SIZE(wl1271_channels),
>        .bitrates = wl1271_rates,
>        .n_bitrates = ARRAY_SIZE(wl1271_rates),
> -       .ht_cap = WL1271_HT_CAP,
> +       .ht_cap = WL12XX_HT_CAP,
>  };
>
>  /* 5 GHz data rates for WL1273 */
> @@ -2386,7 +2386,7 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
>        .n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
>        .bitrates = wl1271_rates_5ghz,
>        .n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
> -       .ht_cap = WL1271_HT_CAP,
> +       .ht_cap = WL12XX_HT_CAP,
>  };
>
>  static const u8 *wl1271_band_rate_to_idx[] = {
> diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/ps.c
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_ps.c
> rename to drivers/net/wireless/wl12xx/ps.c
> index e3c332e..60a3738 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_ps.c
> +++ b/drivers/net/wireless/wl12xx/ps.c
> @@ -21,9 +21,9 @@
>  *
>  */
>
> -#include "wl1271_reg.h"
> -#include "wl1271_ps.h"
> -#include "wl1271_io.h"
> +#include "reg.h"
> +#include "ps.h"
> +#include "io.h"
>
>  #define WL1271_WAKEUP_TIMEOUT 500
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.h b/drivers/net/wireless/wl12xx/ps.h
> similarity index 92%
> rename from drivers/net/wireless/wl12xx/wl1271_ps.h
> rename to drivers/net/wireless/wl12xx/ps.h
> index 6ba7b03..8415060 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_ps.h
> +++ b/drivers/net/wireless/wl12xx/ps.h
> @@ -21,11 +21,11 @@
>  *
>  */
>
> -#ifndef __WL1271_PS_H__
> -#define __WL1271_PS_H__
> +#ifndef __PS_H__
> +#define __PS_H__
>
> -#include "wl1271.h"
> -#include "wl1271_acx.h"
> +#include "wl12xx.h"
> +#include "acx.h"
>
>  int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
>                       u32 rates, bool send);
> diff --git a/drivers/net/wireless/wl12xx/wl1271_reg.h b/drivers/net/wireless/wl12xx/reg.h
> similarity index 100%
> rename from drivers/net/wireless/wl12xx/wl1271_reg.h
> rename to drivers/net/wireless/wl12xx/reg.h
> diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/rx.c
> similarity index 97%
> rename from drivers/net/wireless/wl12xx/wl1271_rx.c
> rename to drivers/net/wireless/wl12xx/rx.c
> index cacfee5..682304c 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_rx.c
> +++ b/drivers/net/wireless/wl12xx/rx.c
> @@ -23,11 +23,11 @@
>
>  #include <linux/gfp.h>
>
> -#include "wl1271.h"
> -#include "wl1271_acx.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_rx.h"
> -#include "wl1271_io.h"
> +#include "wl12xx.h"
> +#include "acx.h"
> +#include "reg.h"
> +#include "rx.h"
> +#include "io.h"
>
>  static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
>                                  u32 drv_rx_counter)
> @@ -61,7 +61,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
>
>        status->rate_idx = wl1271_rate_to_idx(desc->rate, desc_band);
>
> -#ifdef CONFIG_WL1271_HT
> +#ifdef CONFIG_WL12XX_HT
>        /* 11n support */
>        if (desc->rate <= CONF_HW_RXTX_RATE_MCS0)
>                status->flag |= RX_FLAG_HT;
> diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.h b/drivers/net/wireless/wl12xx/rx.h
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_rx.h
> rename to drivers/net/wireless/wl12xx/rx.h
> index 6d41981..3abb26f 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_rx.h
> +++ b/drivers/net/wireless/wl12xx/rx.h
> @@ -22,8 +22,8 @@
>  *
>  */
>
> -#ifndef __WL1271_RX_H__
> -#define __WL1271_RX_H__
> +#ifndef __RX_H__
> +#define __RX_H__
>
>  #include <linux/bitops.h>
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/scan.c
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_scan.c
> rename to drivers/net/wireless/wl12xx/scan.c
> index e0661a5..f3f2c5b 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_scan.c
> +++ b/drivers/net/wireless/wl12xx/scan.c
> @@ -23,10 +23,10 @@
>
>  #include <linux/ieee80211.h>
>
> -#include "wl1271.h"
> -#include "wl1271_cmd.h"
> -#include "wl1271_scan.h"
> -#include "wl1271_acx.h"
> +#include "wl12xx.h"
> +#include "cmd.h"
> +#include "scan.h"
> +#include "acx.h"
>
>  void wl1271_scan_complete_work(struct work_struct *work)
>  {
> diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.h b/drivers/net/wireless/wl12xx/scan.h
> similarity index 97%
> rename from drivers/net/wireless/wl12xx/wl1271_scan.h
> rename to drivers/net/wireless/wl12xx/scan.h
> index 6d57127..421a750 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_scan.h
> +++ b/drivers/net/wireless/wl12xx/scan.h
> @@ -21,10 +21,10 @@
>  *
>  */
>
> -#ifndef __WL1271_SCAN_H__
> -#define __WL1271_SCAN_H__
> +#ifndef __SCAN_H__
> +#define __SCAN_H__
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>
>  int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
>                struct cfg80211_scan_request *req);
> diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/sdio.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_sdio.c
> rename to drivers/net/wireless/wl12xx/sdio.c
> index 784ef34..93cbb8d 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
> +++ b/drivers/net/wireless/wl12xx/sdio.c
> @@ -32,9 +32,9 @@
>  #include <linux/wl12xx.h>
>  #include <linux/pm_runtime.h>
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_io.h"
> +#include "io.h"
>
>  #ifndef SDIO_VENDOR_ID_TI
>  #define SDIO_VENDOR_ID_TI              0x0097
> diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/spi.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_spi.c
> rename to drivers/net/wireless/wl12xx/spi.c
> index ef80168..4671491 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_spi.c
> +++ b/drivers/net/wireless/wl12xx/spi.c
> @@ -28,11 +28,11 @@
>  #include <linux/wl12xx.h>
>  #include <linux/slab.h>
>
> -#include "wl1271.h"
> +#include "wl12xx.h"
>  #include "wl12xx_80211.h"
> -#include "wl1271_io.h"
> +#include "io.h"
>
> -#include "wl1271_reg.h"
> +#include "reg.h"
>
>  #define WSPI_CMD_READ                 0x40000000
>  #define WSPI_CMD_WRITE                0x00000000
> diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.c b/drivers/net/wireless/wl12xx/testmode.c
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_testmode.c
> rename to drivers/net/wireless/wl12xx/testmode.c
> index 55ec442..e64403b 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_testmode.c
> +++ b/drivers/net/wireless/wl12xx/testmode.c
> @@ -20,13 +20,13 @@
>  * 02110-1301 USA
>  *
>  */
> -#include "wl1271_testmode.h"
> +#include "testmode.h"
>
>  #include <linux/slab.h>
>  #include <net/genetlink.h>
>
> -#include "wl1271.h"
> -#include "wl1271_acx.h"
> +#include "wl12xx.h"
> +#include "acx.h"
>
>  #define WL1271_TM_MAX_DATA_LENGTH 1024
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.h b/drivers/net/wireless/wl12xx/testmode.h
> similarity index 93%
> rename from drivers/net/wireless/wl12xx/wl1271_testmode.h
> rename to drivers/net/wireless/wl12xx/testmode.h
> index c196d28..8071654 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_testmode.h
> +++ b/drivers/net/wireless/wl12xx/testmode.h
> @@ -21,8 +21,8 @@
>  *
>  */
>
> -#ifndef __WL1271_TESTMODE_H__
> -#define __WL1271_TESTMODE_H__
> +#ifndef __TESTMODE_H__
> +#define __TESTMODE_H__
>
>  #include <net/mac80211.h>
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/tx.c
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_tx.c
> rename to drivers/net/wireless/wl12xx/tx.c
> index 279be5b..d332b3f 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -24,11 +24,11 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>
> -#include "wl1271.h"
> -#include "wl1271_io.h"
> -#include "wl1271_reg.h"
> -#include "wl1271_ps.h"
> -#include "wl1271_tx.h"
> +#include "wl12xx.h"
> +#include "io.h"
> +#include "reg.h"
> +#include "ps.h"
> +#include "tx.h"
>
>  static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
>  {
> @@ -209,7 +209,7 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
>                rate_set >>= 1;
>        }
>
> -#ifdef CONFIG_WL1271_HT
> +#ifdef CONFIG_WL12XX_HT
>        /* MCS rates indication are on bits 16 - 23 */
>        rate_set >>= HW_HT_RATES_OFFSET - band->n_bitrates;
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/tx.h
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_tx.h
> rename to drivers/net/wireless/wl12xx/tx.h
> index 9dc6f22..903e5dc 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_tx.h
> +++ b/drivers/net/wireless/wl12xx/tx.h
> @@ -22,8 +22,8 @@
>  *
>  */
>
> -#ifndef __WL1271_TX_H__
> -#define __WL1271_TX_H__
> +#ifndef __TX_H__
> +#define __TX_H__
>
>  #define TX_HW_BLOCK_SPARE                2
>  #define TX_HW_BLOCK_SIZE                 252
> diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl12xx.h
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271.h
> rename to drivers/net/wireless/wl12xx/wl12xx.h
> index ab53162..3c836e6 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -22,8 +22,8 @@
>  *
>  */
>
> -#ifndef __WL1271_H__
> -#define __WL1271_H__
> +#ifndef __WL12XX_H__
> +#define __WL12XX_H__
>
>  #include <linux/mutex.h>
>  #include <linux/completion.h>
> @@ -32,8 +32,8 @@
>  #include <linux/bitops.h>
>  #include <net/mac80211.h>
>
> -#include "wl1271_conf.h"
> -#include "wl1271_ini.h"
> +#include "conf.h"
> +#include "ini.h"
>
>  #define DRIVER_NAME "wl1271"
>  #define DRIVER_PREFIX DRIVER_NAME ": "
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
