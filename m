Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:35633 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309Ab1GTTtW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 15:49:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "dcbw@redhat.com" <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 20 Jul 2011 12:40:15 -0700
Subject: RE: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
Message-ID: <477F20668A386D41ADCC57781B1F704307FFBB27E1@SC-VEXCH1.marvell.com> (sfid-20110720_214926_031960_829B1F51)
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	<477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
	<CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com>
	<CAGq3pz4cTSZj+_MwJrxG=Ri1zELKbx2i9Hz==3_=t+aho_Y+Xg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F704307FFBB25D6@SC-VEXCH1.marvell.com>
 <CAGq3pz5M54O4U1WdrqrQgCi4RnfMnw7jhE6T0wWTMT07r+tVMQ@mail.gmail.com>
In-Reply-To: <CAGq3pz5M54O4U1WdrqrQgCi4RnfMnw7jhE6T0wWTMT07r+tVMQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> > Anyway, for users who need this feature we can add a module parameter to enable it with the patch
> below. Please let me know what you think.
> 
> That seems reasonable, but it would probably be preferable to
> implement it as before. Does the cfg80211 wrapper not allow for the
> power command to be implemented by drivers? Is there a
> cfg80211-friendly way of doing it exposed with the iw command?

I will check cfg80211 API for auto deep sleep configuration.

Thanks,
Bing

