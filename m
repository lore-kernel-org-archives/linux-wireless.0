Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:27130 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYC1BXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 21:23:32 -0400
Received: by rv-out-0910.google.com with SMTP id k20so662rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2008 18:23:30 -0700 (PDT)
Message-ID: <1ba2fa240803271823m4adecaeat9ad05ee6bb97969b@mail.gmail.com> (sfid-20080328_012334_939996_D9E51EC1)
Date: Fri, 28 Mar 2008 03:23:28 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: TKIP patches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, what restraining you from applying TKIP patches to wireless-testing
First of all they were acked by Johannes second they need to got into
wider use, most of  the people don't pick up code from the mailing
list but from git directory.
Even TKIP is stupid encryption schema and everybody wants see it dead
it's still used. From our testing our patches reduces significantly
cpu utilization and throughput.
If there are any other issues please let us know

Thanks
Tomas
