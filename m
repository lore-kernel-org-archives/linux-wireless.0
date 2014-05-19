Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:40901 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaESJBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 05:01:14 -0400
Received: by mail-qg0-f41.google.com with SMTP id j5so8308549qga.14
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 02:01:13 -0700 (PDT)
MIME-Version: 1.0
From: Henning Rogge <hrogge@gmail.com>
Date: Mon, 19 May 2014 11:00:53 +0200
Message-ID: <CAGnRvurDvRqeNZYHZQG63=6FQv2XnFOR+J9K4-Dk=F77c6SdKQ@mail.gmail.com> (sfid-20140519_110117_964271_2D3A84FB)
Subject: 802.11s mode without HWMP
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I would be interested in running the 802.11s mode of the linux wifi
stack without the mesh switching protocol.

802.11s with its 6-address frame format could be a great improvement
over IBSS mode because it allows to attach the local wifi card to a
bridge. We are using Layer-3 routing for establishing the mesh, so
HWMP would just interfere with out usecase.

Is there an easy way to stop HWMP in the 802.11s implementation? This
would restrict unicast and multicast communication to just direct
connections like IBSS mode.

Henning Rogge
