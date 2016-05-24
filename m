Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3190 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbcEXPa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 11:30:29 -0400
From: "Pukitis, Martins" <martins.pukitis@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: AP statistics
Date: Tue, 24 May 2016 15:29:44 +0000
Message-ID: <22AF109346512440A803B8D2E69399ECA7AA7E@IRSMSX103.ger.corp.intel.com> (sfid-20160524_173032_723462_2113D66F)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.
Is there cfg80211 API for getting AP statistics (bytes sent/received, packets sent/received/dropped)? I know there is "get_station", but it reads per station statistics. Stations may disconnect, hence you can't just sum together all station statistics to get per AP statistics.
