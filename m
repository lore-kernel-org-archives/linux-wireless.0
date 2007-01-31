Return-path: <wireless-bounces@tuxdriver.com>
Received: from ra.tuxdriver.com (ra.tuxdriver.com [127.0.0.1])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V247fq002993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 21:04:12 -0500
Received: (from uucp@localhost)
	by ra.tuxdriver.com (8.13.7/8.13.6/Submit) with UUCP id l0V1jOoe002605
	for wireless@lists.tuxdriver.org; Tue, 30 Jan 2007 20:45:24 -0500
Received: from linville-t43.mobile (linville-t43.mobile [127.0.0.1])
	by linville-t43.mobile (8.13.8/8.13.8) with ESMTP id l0V1bHOb028238
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 20:37:17 -0500
Received: (from linville@localhost)
	by linville-t43.mobile (8.13.8/8.13.8/Submit) id l0V1bHjM028237
	for wireless@lists.tuxdriver.org; Tue, 30 Jan 2007 20:37:17 -0500
Date: Tue, 30 Jan 2007 20:37:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: wireless@lists.tuxdriver.org
Subject: [RFC] cfg80211 merge
Message-ID: <20070131013717.GA28076@tuxdriver.com>
Mime-Version: 1.0
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

In London we agreed that it would be good to go ahead and merge
cfg80211.  This provides some exposure to the API and eases some of
the pain for driver maintainers (who won't have to follow wireless-dev
to get it).

I have refactored the cfg80211-related patches down to three patches.
This eliminates some of the churn in the series from wireless-dev,
and each patch leaves a buildable tree.

Let me know if I've left anything out, screwed anything up, or if
you no longer think a cfg80211 merge is appropriate at this time.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
