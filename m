Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54627 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbZFRDKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 23:10:14 -0400
Date: Thu, 18 Jun 2009 00:10:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] rfkill: export persistent attribute in sysfs
Message-ID: <20090618031015.GF29569@khazad-dum.debian.net>
References: <4A37A3FC.9060206@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A37A3FC.9060206@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 16 Jun 2009, Alan Jenkins wrote:
> + * can be read by userspace.  Persistent devices are expected to preserve
> + * preserve their own state when suspended.

You have "preserve" twice in there.

Other than that,

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
