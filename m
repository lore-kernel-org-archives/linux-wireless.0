Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39950 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1GTQ4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:56:05 -0400
Received: by fxd18 with SMTP id 18so2040017fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 09:56:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FFBB25D6@SC-VEXCH1.marvell.com>
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	<477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
	<CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com>
	<CAGq3pz4cTSZj+_MwJrxG=Ri1zELKbx2i9Hz==3_=t+aho_Y+Xg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F704307FFBB25D6@SC-VEXCH1.marvell.com>
Date: Wed, 20 Jul 2011 17:56:04 +0100
Message-ID: <CAGq3pz5M54O4U1WdrqrQgCi4RnfMnw7jhE6T0wWTMT07r+tVMQ@mail.gmail.com> (sfid-20110720_185610_984089_8C48654E)
Subject: Re: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: "dcbw@redhat.com" <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2011 03:33, Bing Zhao <bzhao@marvell.com> wrote:
> Yeah. I didn't know that the entire wext has been removed from libertas.
>
> Anyway, for users who need this feature we can add a module parameter to enable it with the patch below. Please let me know what you think.

That seems reasonable, but it would probably be preferable to
implement it as before. Does the cfg80211 wrapper not allow for the
power command to be implemented by drivers? Is there a
cfg80211-friendly way of doing it exposed with the iw command?


John, please drop this patch (looks like this functionality will be
revived soon). Also, I've resent the other patches in this series with
minor changes.

Thanks,
Daniel
