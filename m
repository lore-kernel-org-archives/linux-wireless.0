Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41472 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2DMUAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 16:00:51 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q3DK0oH4008211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2012 13:00:50 -0700
Message-ID: <4F8885F1.3060802@candelatech.com> (sfid-20120413_220055_179087_697B446E)
Date: Fri, 13 Apr 2012 13:00:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Any way to get channel index from channel?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the ethtool stats patches, I'm trying to get the
survey for just the current operating channel.
(Previously posted code is wrong..can't just use index 0, duh!)

I know the channel object: local->oper_channel
but the API that gets survey results wants the channel
index.

Is there a fast way to get the channel index from a channel,
or do I just need to iterate through all channels and compare
the center-frequencies?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

