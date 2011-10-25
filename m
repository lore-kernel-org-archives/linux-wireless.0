Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab1JYKSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:18:46 -0400
Received: by wwe6 with SMTP id 6so553020wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 03:18:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Oct 2011 12:18:44 +0200
Message-ID: <CACVrECFG2ND-yEZAZq2n2Y2nU=71ZUz8UNiqwbdU+N+c_hvcsw@mail.gmail.com> (sfid-20111025_121849_588113_5D71A165)
Subject: Ath5k driver. /sys/class/net/$interface/statistics - not updated
From: Mariana Gambande <mlgambande@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello to all,

I've been working with ad-hoc mode and master/station mode on several
machines trying to test the Layer 2 performance over wireless links.
I'm working with driver ath5k.
After various tests with simple pings and using iperf (for hours) I
see I never get a value different to 0 in the following variables
according to /sys/class/net/$interface/statistics directory:

rx_errors 	rx_length_errors	tx_aborted_errors	tx_compressed
tx_errors 	rx_over_errors		tx_carrier_errors
rx_dropped 	rx_crc_errors		tx_fifo_errors
tx_dropped 	rx_frame_errors		tx_heartbeat_errors
multicast 	rx_fifo_errors		tx_window_errors
collisions      rx_missed_errors      	rx_compressed

This has been so for nodes in mode ad-hoc, managed and master. Is it
possible that this directory is not being updated properly?

I've been using:
- compat-wireless-2.6.35-1 (kernel 2.6.35), compat-wireless-2.6.38.2-2
(kernel 2.6.38).
- driver ath5k.
- all tests where performed using channel 1 for ad-hoc mode and
channel 36 for master/station mode.
- devices AR5413 802.11abg and AR5001X+ Wireless Network Adapter.

Thanks in advance,
Mariana.
