Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:60936 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909Ab3C2Spm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 14:45:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 29 Mar 2013 11:44:48 -0700
Subject: RE: mwifiex crash when removing interface while scanning
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DCBF0E7@SC-VEXCH1.marvell.com> (sfid-20130329_194546_438883_C715373A)
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
	<CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
	<CAMLZHHR+OCQd_2J8NkmK0CND9vo6VaT73L+rJKJRk7bUknh7Qw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CEC9D@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C1608@SC-VEXCH1.marvell.com>
	<CAMLZHHQyTDHD8q=Q-edSew+KnpaGWOaVwxiK_fjABG9ZC9g-Qg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C2199@SC-VEXCH1.marvell.com>
	<CAMLZHHQYB8wYEq1gppNEMiV0BPfM3qKtujR4=4u1jVww-N6z5w@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD3AE4@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD430D@SC-VEXCH1.marvell.com>
	<CAMLZHHRmyftv4sz+jmozJoAjvRTP-4DF-59C6N22R7tccCJ5WQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DCBEBB7@SC-VEXCH1.marvell.com>
 <CAMLZHHT92u7gAGyfnqo_4S=+MgmEu0iW0bCbQ1jPycuRWf_6fQ@mail.gmail.com>
In-Reply-To: <CAMLZHHT92u7gAGyfnqo_4S=+MgmEu0iW0bCbQ1jPycuRWf_6fQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> On Wed, Mar 27, 2013 at 8:24 PM, Bing Zhao <bzhao@marvell.com> wrote:
> > This is caused by decreasing cmd_pending while cleanup scan commands in scan_pending_q.
> > cmd_pending only counts the commands queued in cmd_pending_q.
> >
> > Attached v2 patch should fix it. Please try it out.
> 
> Thanks, applied both patches, that seems to be working now.

Thanks for testing. I will resend the patches to the list.

Thanks,
Bing
