Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53766 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0FOWnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 18:43:41 -0400
Received: by pva4 with SMTP id 4so376177pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 15:43:40 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Jun 2010 15:43:20 -0700
Message-ID: <AANLkTim4iS9gvwttEBhUdMwCkZQlUH1kA8zlf_O1dFLF@mail.gmail.com>
Subject: Pending stable patches for 802.11 sent
To: Greg KH <greg@kroah.com>, stable@kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per this list:

http://wireless.kernel.org/en/developers/stable-pending

we have sent all pending patches. Vivek sent the respective port for
"ath9k: Avoid corrupt frames being forwarded to mac80211" for 2.6.32,
2.6.33 and 2.6.34. This last one was split into two patches one for
2.6.33 and 2.6.34, and the other backport for 2.6.32.

I am not aware of any other pending patches, if anyone is please peg
them to the wiki list for tacking purposes.

  Luis
