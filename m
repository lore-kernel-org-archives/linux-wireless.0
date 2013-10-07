Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:51053 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3JGRaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 13:30:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2] bluetooth: fix variable shadow warnings
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1381162756-18353-1-git-send-email-johannes@sipsolutions.net>
Date: Mon, 7 Oct 2013 18:53:38 +0200
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Message-Id: <815BA104-681B-4C6B-AD03-E52EB8834904@holtmann.org> (sfid-20131007_193005_512613_5380157D)
References: <1381162756-18353-1-git-send-email-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Sparse points out three places where variables are shadowed,
> rename two of the variables and remove the duplicate third.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> net/bluetooth/hci_event.c  | 12 +++++++-----
> net/bluetooth/l2cap_sock.c |  2 +-
> 2 files changed, 8 insertions(+), 6 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

