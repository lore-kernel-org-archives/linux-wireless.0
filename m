Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49532 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab1ISTpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:45:46 -0400
Date: Mon, 19 Sep 2011 15:31:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Greg Dietsche <gregory.dietsche@cuw.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-09-14
Message-ID: <20110919193122.GD2608@tuxdriver.com> (sfid-20110919_214551_388347_11D14B6B)
References: <20110914085900.GA2717@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110914085900.GA2717@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 10:59:16AM +0200, Stanislaw Gruszka wrote:
> John,
> 
> Please pull iwlegacy cleanup changes done by Greg and me, intended
> for 3.2. These request include huge patches with file renaming and
> automatic code processing done by sed and indent. Work of changing
> iwlegacy driver into something that I could consider maintainable
> is not done yet, but these massive changes bring closer into that.
> Hopefully with having clean, maintainable code I will be able to
> fix some nasty, not easy reproducible bugs, we still have in the
> iwlegacy driver.
> 
> Thanks.
> 
> The following changes since commit d82cdad64a0127611724c61849a8487d69fb76ef:
> 
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next (2011-08-30 16:34:33 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/dietsche/linux.git wireless-next-iwlegacy-stanislaw-greg

It looks like you pulled something other than wireless-next into this
tree.  If you want me to pull directly, then you need to based your
tree (or at least the branch I'm pulling) on wireless-next exclusively.

Thanks,

John

[linville-8530p.local]:> git pull git://github.com/dietsche/linux.git wireless-next-iwlegacy-stanislaw-greg
remote: Counting objects: 5879, done.
remote: Compressing objects: 100% (1686/1686), done.
remote: Total 4450 (delta 3658), reused 3527 (delta 2753)
Receiving objects: 100% (4450/4450), 1.56 MiB | 969 KiB/s, done.
Resolving deltas: 100% (3658/3658), completed with 719 local objects.
>From git://github.com/dietsche/linux
 * branch            wireless-next-iwlegacy-stanislaw-greg -> FETCH_HEAD
Removing Documentation/DocBook/dvb/dvbproperty.xml
Removing Documentation/DocBook/dvb/dvbstb.png
Removing Documentation/DocBook/dvb/frontend.h.xml
Removing Documentation/DocBook/media-entities.tmpl
Removing Documentation/DocBook/media-indices.tmpl
Auto-merging Documentation/DocBook/media/dvb/audio.xml
Auto-merging Documentation/DocBook/media/dvb/ca.xml
Auto-merging Documentation/DocBook/media/dvb/demux.xml
Auto-merging Documentation/DocBook/media/dvb/dvbapi.xml
Auto-merging Documentation/DocBook/media/dvb/frontend.xml
Auto-merging Documentation/DocBook/media/dvb/intro.xml
Auto-merging Documentation/DocBook/media/dvb/net.xml
Auto-merging Documentation/DocBook/media/dvb/video.xml
Auto-merging Documentation/DocBook/media/v4l/common.xml
Auto-merging Documentation/DocBook/media/v4l/compat.xml
Auto-merging Documentation/DocBook/media/v4l/controls.xml
Auto-merging Documentation/DocBook/media/v4l/lirc_device_interface.xml
Auto-merging Documentation/DocBook/media/v4l/media-func-ioctl.xml
Auto-merging Documentation/DocBook/media/v4l/media-ioc-device-info.xml
Auto-merging Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
Auto-merging Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
Auto-merging Documentation/DocBook/media/v4l/pixfmt.xml
Auto-merging Documentation/DocBook/media/v4l/subdev-formats.xml
Auto-merging Documentation/DocBook/media/v4l/v4l2.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-cropcap.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-dqevent.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-audio.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-crop.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-input.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-output.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-parm.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-priority.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-g-std.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-log-status.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-overlay.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-qbuf.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-querycap.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-querystd.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-streamon.xml
Auto-merging Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
Auto-merging Documentation/DocBook/media_api.tmpl
Removing Documentation/DocBook/v4l/bayer.pdf
Removing Documentation/DocBook/v4l/bayer.png
Removing Documentation/DocBook/v4l/crop.gif
Removing Documentation/DocBook/v4l/dev-event.xml
Removing Documentation/DocBook/v4l/fieldseq_bt.gif
Removing Documentation/DocBook/v4l/fieldseq_tb.gif
Removing Documentation/DocBook/v4l/func-ioctl.xml
Removing Documentation/DocBook/v4l/nv12mt.gif
Removing Documentation/DocBook/v4l/nv12mt_example.gif
Removing Documentation/DocBook/v4l/pipeline.png
Removing Documentation/DocBook/v4l/vbi_525.gif
Removing Documentation/DocBook/v4l/vbi_625.gif
Removing Documentation/DocBook/v4l/vbi_hsync.gif
Removing Documentation/DocBook/v4l/videodev2.h.xml
Removing Documentation/DocBook/v4l/vidioc-subscribe-event.xml
Auto-merging MAINTAINERS
Removing arch/arm/lib/sha1.S
Removing arch/arm/mach-mmp/include/mach/mfp-gplugd.h
Removing arch/arm/mach-msm/gpio.c
Removing arch/arm/mach-msm/gpio_hw.h
Removing arch/arm/mach-zynq/board_dt.c
Removing arch/sparc/include/asm/div64.h
Removing arch/sparc/include/asm/irq_regs.h
Removing arch/sparc/include/asm/local.h
Removing arch/sparc/include/asm/local64.h
Removing arch/sparc/lib/NG2page.S
Removing arch/tile/include/asm/bug.h
Removing arch/tile/include/asm/bugs.h
Removing arch/tile/include/asm/cputime.h
Removing arch/tile/include/asm/device.h
Removing arch/tile/include/asm/div64.h
Removing arch/tile/include/asm/emergency-restart.h
Removing arch/tile/include/asm/errno.h
Removing arch/tile/include/asm/fb.h
Removing arch/tile/include/asm/fcntl.h
Removing arch/tile/include/asm/ioctl.h
Removing arch/tile/include/asm/ioctls.h
Removing arch/tile/include/asm/ipc.h
Removing arch/tile/include/asm/ipcbuf.h
Removing arch/tile/include/asm/irq_regs.h
Removing arch/tile/include/asm/kdebug.h
Removing arch/tile/include/asm/local.h
Removing arch/tile/include/asm/module.h
Removing arch/tile/include/asm/msgbuf.h
Removing arch/tile/include/asm/mutex.h
Removing arch/tile/include/asm/param.h
Removing arch/tile/include/asm/parport.h
Removing arch/tile/include/asm/poll.h
Removing arch/tile/include/asm/posix_types.h
Removing arch/tile/include/asm/resource.h
Removing arch/tile/include/asm/scatterlist.h
Removing arch/tile/include/asm/sembuf.h
Removing arch/tile/include/asm/serial.h
Removing arch/tile/include/asm/shmbuf.h
Removing arch/tile/include/asm/shmparam.h
Removing arch/tile/include/asm/socket.h
Removing arch/tile/include/asm/sockios.h
Removing arch/tile/include/asm/statfs.h
Removing arch/tile/include/asm/termbits.h
Removing arch/tile/include/asm/termios.h
Removing arch/tile/include/asm/types.h
Removing arch/tile/include/asm/ucontext.h
Removing arch/tile/include/asm/xor.h
Auto-merging drivers/gpio/gpio-msm-v2.c
Auto-merging drivers/hwmon/pmbus/adm1275.c
Auto-merging drivers/hwmon/pmbus/max16064.c
Auto-merging drivers/hwmon/pmbus/max34440.c
Auto-merging drivers/hwmon/pmbus/max8688.c
Auto-merging drivers/hwmon/pmbus/pmbus.c
Auto-merging drivers/hwmon/pmbus/pmbus.h
Auto-merging drivers/hwmon/pmbus/pmbus_core.c
Removing drivers/media/video/cafe_ccic-regs.h
Removing drivers/media/video/cafe_ccic.c
Removing drivers/media/video/pwc/pwc-ioctl.h
Removing drivers/media/video/pwc/pwc-uncompress.h
Auto-merging drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
Auto-merging drivers/net/wireless/ath/ath9k/ar9003_phy.c
Auto-merging drivers/net/wireless/ath/ath9k/ar9003_phy.h
Auto-merging drivers/net/wireless/ath/ath9k/main.c
Auto-merging drivers/net/wireless/iwlegacy/4965-calib.c
Auto-merging drivers/net/wireless/iwlegacy/commands.h
Auto-merging drivers/net/wireless/iwlegacy/csr.h
Removing drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
Removing drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
Removing drivers/net/wireless/iwlegacy/iwl-3945-fh.h
Removing drivers/net/wireless/iwlegacy/iwl-3945-hw.h
Removing drivers/net/wireless/iwlegacy/iwl-3945-led.c
Removing drivers/net/wireless/iwlegacy/iwl-3945-led.h
Removing drivers/net/wireless/iwlegacy/iwl-3945-rs.c
Removing drivers/net/wireless/iwlegacy/iwl-3945.c
Removing drivers/net/wireless/iwlegacy/iwl-3945.h
Removing drivers/net/wireless/iwlegacy/iwl-4965-calib.h
Removing drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
Removing drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-hw.h
Removing drivers/net/wireless/iwlegacy/iwl-4965-led.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-led.h
Removing drivers/net/wireless/iwlegacy/iwl-4965-lib.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-rs.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-rx.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-sta.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-tx.c
Removing drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
Removing drivers/net/wireless/iwlegacy/iwl-4965.c
Removing drivers/net/wireless/iwlegacy/iwl-4965.h
Removing drivers/net/wireless/iwlegacy/iwl-core.c
Removing drivers/net/wireless/iwlegacy/iwl-core.h
Removing drivers/net/wireless/iwlegacy/iwl-debug.h
Removing drivers/net/wireless/iwlegacy/iwl-debugfs.c
Removing drivers/net/wireless/iwlegacy/iwl-dev.h
Removing drivers/net/wireless/iwlegacy/iwl-devtrace.c
Removing drivers/net/wireless/iwlegacy/iwl-devtrace.h
Removing drivers/net/wireless/iwlegacy/iwl-eeprom.c
Removing drivers/net/wireless/iwlegacy/iwl-eeprom.h
Removing drivers/net/wireless/iwlegacy/iwl-fh.h
Removing drivers/net/wireless/iwlegacy/iwl-hcmd.c
Removing drivers/net/wireless/iwlegacy/iwl-helpers.h
Removing drivers/net/wireless/iwlegacy/iwl-io.h
Removing drivers/net/wireless/iwlegacy/iwl-led.c
Removing drivers/net/wireless/iwlegacy/iwl-led.h
Removing drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
Removing drivers/net/wireless/iwlegacy/iwl-power.c
Removing drivers/net/wireless/iwlegacy/iwl-power.h
Removing drivers/net/wireless/iwlegacy/iwl-rx.c
Removing drivers/net/wireless/iwlegacy/iwl-scan.c
Removing drivers/net/wireless/iwlegacy/iwl-sta.c
Removing drivers/net/wireless/iwlegacy/iwl-sta.h
Removing drivers/net/wireless/iwlegacy/iwl-tx.c
Removing drivers/net/wireless/iwlegacy/iwl3945-base.c
Removing drivers/net/wireless/iwlegacy/iwl4965-base.c
Auto-merging drivers/net/wireless/iwlegacy/prph.h
Auto-merging drivers/net/wireless/iwlwifi/iwl-pci.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-pci.c
Auto-merging drivers/net/wireless/rt2x00/rt2800usb.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt2800usb.c
Auto-merging drivers/net/wireless/wl12xx/main.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/main.c
Auto-merging drivers/staging/zcache/zcache-main.c
Auto-merging drivers/watchdog/at91sam9_wdt.h
Removing fs/btrfs/ref-cache.c
Removing fs/btrfs/ref-cache.h
Auto-merging fs/exofs/ore.c
Removing fs/exofs/pnfs.h
Auto-merging fs/xfs/xfs_acl.c
Auto-merging fs/xfs/xfs_buf.c
Auto-merging fs/xfs/xfs_buf.h
Auto-merging fs/xfs/xfs_dquot.c
Auto-merging fs/xfs/xfs_linux.h
Auto-merging fs/xfs/xfs_qm.c
Auto-merging fs/xfs/xfs_quotaops.c
Auto-merging fs/xfs/xfs_sync.c
Auto-merging fs/xfs/xfs_trace.c
Auto-merging include/net/cfg80211.h
Auto-merging include/sound/wm8996.h
Auto-merging net/wireless/core.c
Removing scripts/kconfig/kconfig_load.c
Removing sound/soc/codecs/wm8915.c
Removing sound/soc/codecs/wm8915.h
Automatic merge failed; fix conflicts and then commit the result.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
