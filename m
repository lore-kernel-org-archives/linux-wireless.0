Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33121 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1FKRrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:32 -0400
Received: by qwk3 with SMTP id 3so1720196qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jun 2011 10:47:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 11 Jun 2011 19:47:31 +0200
Message-ID: <BANLkTimaUBe6kszbvSeSPTXR6m1t8C8O-A@mail.gmail.com> (sfid-20110611_194737_756140_19321743)
Subject: Can iperf work with no qos? (TCP mode)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can not get any results when trying to use iperf in TCP mode with
driver not supporting qos.

Is this expected? Does iperf fill connection with so many packets,
it's not possible to get response from the iperf receiver? Should not
Linux somehow schedule packet to allow bi-direction communication,
even on really filled connection?

-- 
Rafał
