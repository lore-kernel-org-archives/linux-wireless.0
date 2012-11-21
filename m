Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42897 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2KUIkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 03:40:51 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so3322451vcm.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2012 00:40:51 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 21 Nov 2012 03:40:51 -0500
Message-ID: <CA+7oygeWvsbrNz3k8ypqK=J6LMg1Zx0dN8S+ee-ywGEgtvQxqQ@mail.gmail.com> (sfid-20121121_094055_898265_89B247B0)
Subject: what dictates p2p0 address?
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For an ad-hoc or Wifi-Direct interface, which usually seems to be
named p2p0, I'm finding that the MAC address mirrors the Wifi card's
MAC address for octets 2-6, but it seems as though octet 1 is dynamic.
 So, for example:

Wifi: 7c:d1:c3:e0:a6:81
p2p0: 0e:d1:c3:e0:a6:81

This is true across a bunch of devices that I own, but I can't seem to
find a definitive answer to how octet 1 is mutated to choose the p2p0
address.

Is this something chosen randomly, or is it a function of some other
part of the address?

- George
