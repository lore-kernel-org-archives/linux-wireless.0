Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:43306 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2KPRlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 12:41:19 -0500
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id Am6QEcBTnxMK66Fv (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2012 12:41:14 -0500 (EST)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: help: 802.11s bad performance with 802.11n enabled
Date: Fri, 16 Nov 2012 17:41:13 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10E97@RockMX01.rock.corp> (sfid-20121116_184123_139052_EA7095E9)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I set up a 7 node 802.11s mesh network and try to evaluate network performance.

My first test is to evaluate packet loss.
My test utility is very simple. Do a continuous ping to all 7 nodes. And count the ping replies. The ping rate is about 10 ping requests per second to each node.

802.11a channel 40. Clean RF environment, nobody else is on this channel

When 802.11n is NOT enabled, the ping loss rate is very good. Only a few packets are lost during an overnight test.

However, when 802.11n (HT40+ or HT20) is enabled, the network is crazily unstable. The ping loss is about 30% or more to each node. 

FYI, The 802.11n itself seems to work well with 802.11s when there are only 2 nodes (standalone). I say so because I did throughput test on a 2 node mesh with channel 40 HT40+. The throughput was good. IPERF TCP throughput is about 170Mbps out of 300Mbps (2 streams).


Does anyone know what's going on?
Or anyone did 802.11s performance test and can share the test data/setup, etc?


Thanks,

Chaoxing
