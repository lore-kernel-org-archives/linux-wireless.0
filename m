Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:63068 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZISSvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 14:51:24 -0400
Received: by qyk3 with SMTP id 3so1527662qyk.4
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2009 11:51:27 -0700 (PDT)
MIME-Version: 1.0
Reply-To: kzeng@cs.ucdavis.edu
Date: Sat, 19 Sep 2009 11:51:27 -0700
Message-ID: <af77b8a80909191151ya424ea0j794f962b9dc997a9@mail.gmail.com>
Subject: About calculation of RSSI in iwlwifi 5300agn
From: kai zeng <kzeng@cs.ucdavis.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Does any one know how the RSSI is calculated in iwlwifi 5300agn?
Specifically, what's the function used to map the actual signal
strength to RSSI?

Thanks,

Kai
