Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:35123 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbXLDG5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 01:57:48 -0500
Received: by py-out-1112.google.com with SMTP id u77so7014415pyb
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2007 22:57:47 -0800 (PST)
Message-ID: <f6ca9fed0712032257p225f97f3pae00b878f15d09@mail.gmail.com> (sfid-20071204_065750_547441_67A5AE35)
Date: Tue, 4 Dec 2007 07:57:47 +0100
From: dragoran <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Cc: "Jouni Malinen" <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <f6ca9fed0712030347s3d1fde9cnad9046c83316163b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu>
	 <1196676895.6060.19.camel@johannes.berg>
	 <f6ca9fed0712030347s3d1fde9cnad9046c83316163b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 3, 2007 12:47 PM, dragoran <drago01@gmail.com> wrote:
> It seems not to happen today (with an updated kernel 2.6.23.9-77.fc8;
> which contains recent wireless updates from #everything).
> I don't know if its fixed or if the I am just not receiving crap right
> now... but will be connected for ~4hours to this ap now..
> will report if it happens or not until then...
>

ok confirmed it does no longer happen with the updated kernel.
maybe the drop_unencrypted stuff fixed it...
