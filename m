Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52209 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GSSgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 14:36:14 -0400
Received: by fxd18 with SMTP id 18so394342fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 11:36:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com>
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	<477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
	<CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com>
Date: Tue, 19 Jul 2011 19:36:13 +0100
Message-ID: <CAGq3pz4cTSZj+_MwJrxG=Ri1zELKbx2i9Hz==3_=t+aho_Y+Xg@mail.gmail.com> (sfid-20110719_203618_162914_2B0E7E4C)
Subject: Re: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"dcbw@redhat.com" <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 July 2011 19:23, Bing Zhao <bzhao@marvell.com> wrote:
> To enable deep sleep mode:
> iwconfig wlan0 power period 0
>
> To enable auto deep sleep mode with idle time period set to 5 seconds:
> iwconfig wlan0 power period 5
>
> To disable deep sleep/auto deep sleep mode:
> iwconfig wlan0 power period -1

Paul pointed out that indeed, in old kernels, this functionality was
hooked up to the power wireless extension.

In recent kernels, this is not the case - its not hooked up to
anything. The commands you write above will fail.

Daniel
